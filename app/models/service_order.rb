 # encoding: utf-8
require "securerandom"
require "csv"
class ServiceOrder < ActiveRecord::Base
  attr_accessible :alipay_id, :alipay_pix, :cmobile, :cname, :price, :site_id, 
  					:site_pix, :site_worker_id, :status, :tb_trade_id, :uid, :user_id,
  					:time_service,:memo,:time_pay

  belongs_to :tb_trade
  belongs_to :site
  belongs_to :user
  scope :status, lambda {|status| where(:status => status)}
  
  state_machine :status, :initial => :pending do
    
    # pending #地址不正确，等待修改   
    event :assign  do
      transition [:pending,:assigned]=>:assigned #指派第一次
    end

    # event :reassign  do
    #   transition []=>:assigned #客服重新指派
    # end
    event :inform  do
      transition [:informed,:assigned]=>:informed #安装
    end

    event :install  do
      transition :informed=>:installation #安装
    end

    event :pay  do
      transition :installation=>:payed #支付
    end

    event :cancle  do
      transition [:assigned,:installation]=>:cancled #取消
    end

    event :revert  do
      transition :payed=>:installation,:installation=>:informed,:informed=>:assigned,:assigned=>:pending
    end

    after_transition :informed => :installation do |service_order,transition|
      service_order.time_service = DateTime.now
      service_order.save!
    end
    after_transition :installation => :payed do |service_order,transition|
      service_order.time_pay = DateTime.now
      service_order.save!
    end

    after_transition :pending => :assigned do |service_order,transition|
      # service_order.send_assign_sms
    end

    after_transition [:informed,:assigned] => :informed do |service_order,transition|
      # service_order.send_cancle transition.args[0]
      service_order.send_assign_sms
    end

    after_transition :assigned => :cancled do |service_order,transition|
      # service_order.send_cancle
    end
  end

  def self.create_from_trade tb_trade 
    #tb_trade->site
    logger.info "create_from_trade--#{tb_trade.id}--start"
    user = tb_trade.user
    service_order = user.service_orders.build(:uid=>"%012d" % SecureRandom.random_number(1000000000000),
                                :cname=>tb_trade.cname,:cmobile=>tb_trade.cmobile,
                                :status=>:pending,:tb_trade_id=>tb_trade.id)
    tb_trade.service_order = service_order
    # site = user.sites.city(tb_trade.city).order(:cert).last || Site.find_near(tb_trade.city)
    site = user.find_site(tb_trade)
    logger.info "create_from_trade--#{tb_trade.id}--find site"
    if site then
      service_order.site = site
      service_order.status = "assigned"
      service_order.save!
      tb_trade.status = "assigned"
    else
      tb_trade.status = "imported"
    end
    logger.info "create_from_trade--#{tb_trade.id}--save again"
    tb_trade.save!
    logger.info "create_from_trade--#{tb_trade.id}--out"
    return service_order
  end

  def set_site site
    if site then
      self.site_id = site.id
    else
      self.status = "pending"
    end
    self.save!
  end


  def send_cancle site
    message_s = "服务预约取消:#{time_service.strftime("%F %H")}，客户:#{cname}，联系电话:#{cmobile},订单信息:"
    SmsWorker.new.perform site.phone,message_s
  end

  def send_assign_sms
  	# message_s = "服务预约时间:#{time_service.strftime("%F %H")}，客户:#{cname}，联系电话:#{cmobile},订单信息:"  	
  	# message_c = "#{cname}，服务预约时间:#{time_service.strftime("%F %H点")},#{site.summary}"
  	# SmsWorker.new.perform site.phone,message_s
  	# # SmsWorker.perform_async cmobile,message_c
   #  SmsWorker.new.perform cmobile,message_c
    if Setting[:sms_send] then
      msg_c = assign_sms_c
      SmsWorker.perform_async user.id,cmobile,msg_c if msg_c.length>0 && cmobile
      msg_s = assign_sms_s
      SmsWorker.perform_async user.id,site.phone,msg_s if msg_s.length>0 && site.phone
    else
      logger.info "sms #{cmobile}--->>>#{assign_sms}"
    end
  end

  def site_sms
    assign_sms_s
  end

  def assign_sms
    assign_sms_c
  end

  def assign_sms_c
    template = user.sms_templates.where(:sms_type=>"inform").first
    return "" if !template  
    template = '<%="'+template.content+'"%>' 
    vars = {phone:site.phone,contactor:site.contactor,tid:tb_trade.tid,address:site.address,name:site.name}
    ERB.new(template).result(OpenStruct.new(vars).instance_eval{binding})
  end

  def assign_sms_s
    template = user.sms_templates.where(:sms_type=>"site").first  
    return "" if !template  
    template = '<%="'+template.content+'"%>' 
    vars = {phone:tb_trade.cmobile,contactor:tb_trade.cname,product:tb_trade.title}
    ERB.new(template).result(OpenStruct.new(vars).instance_eval{binding})
  end

  def time flag=nil
    case flag
    when :pay
      return time_pay
    when :service
      return time_service
    else
      return updated_at
    end
  end

  def txt_status
    case status
    when "pending"
      "待分配"
    when "assigned"
      "待通知"
    when "informed"
      "待安装"
    when "installation"
      "待付款"
    when "payed"
      "已付款"
    end 
  end

  def self.to_csv
    column_names = ["uid","cname","cmobile","time_service","time_pay","memo"]
    CSV.generate do |csv|
      csv << column_names
      all.each do |product|
        csv << product.attributes.values_at(*column_names)
      end
    end
  end

end
