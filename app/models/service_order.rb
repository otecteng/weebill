 # encoding: utf-8
require "securerandom"
class ServiceOrder < ActiveRecord::Base
  default_scope order('created_at DESC')

  attr_accessible :alipay_id, :alipay_pix, :cmobile, :cname, :price, :site_id, 
  					:site_pix, :site_worker_id, :status, :tb_trade_id, :uid, :user_id,
  					:time_service,:memo

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
    user = tb_trade.user
    service_order = user.service_orders.build(:uid=>"%012d" % SecureRandom.random_number(1000000000000),
                                :cname=>tb_trade.cname,:cmobile=>tb_trade.cmobile,
                                :status=>:pending,:tb_trade_id=>tb_trade.id)
    tb_trade.service_order = service_order
    # site = user.sites.city(tb_trade.city).order(:cert).last || Site.find_near(tb_trade.city)
    site = user.find_site(tb_trade)
    if site then
      service_order.site = site
      service_order.status = "assigned"
      service_order.save!
      tb_trade.status = "assigned"
    else
      tb_trade.status = "imported"
    end
    tb_trade.save!
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
      SmsWorker.perform_async user.id,cmobile,assign_sms
    else
      logger.info "sms #{cmobile}--->>>#{assign_sms}"
    end
  end

  def site_sms
    "感谢您选择与航睿导航合作安装！客户订单号(#{tb_trade.tid})客户信息:#{cname}(#{cmobile})"
  end

  def assign_sms
    template = "感谢选购航睿导航！收货后请致电体验店预约,电话:#{site.phone}(#{site.contactor}),预约号#{tb_trade.tid},地址:#{site.address}-[#{site.name}],投诉建议请拨打18666688652,祝您购物愉快！"
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

end
