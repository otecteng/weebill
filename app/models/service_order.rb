 # encoding: utf-8
require "securerandom"
class ServiceOrder < ActiveRecord::Base
  attr_accessible :alipay_id, :alipay_pix, :cmobile, :cname, :price, :site_id, 
  					:site_pix, :site_worker_id, :status, :tb_trade_id, :uid, :user_id,
  					:time_service,:memo

  has_one :tb_trade
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

    event :install  do
      transition :assigned=>:installation #安装
    end

    event :pay  do
      transition :installation=>:payed #支付
    end

    event :cancle  do
      transition [:assigned,:installation]=>:cancled #取消
    end

    after_transition :pending => :assigned do |service_order,transition|
      service_order.send_assign_sms
    end

    after_transition :assigned => :assigned do |service_order,transition|
      service_order.send_cancle transition.args[0]
      service_order.send_assign_sms
    end

    after_transition :assigned => :cancled do |service_order,transition|
      service_order.send_cancle
    end
  end

  def self.create_from_trade tb_trade 
    #tb_trade->site
    user = tb_trade.user
    site = user.sites.city(tb_trade.city).order(:cert).last || Site.find_near(tb_trade.city)
    service_order = user.service_orders.build(:uid=>SecureRandom.random_number(1000000000000),
                                :cname=>tb_trade.cname,:cmobile=>tb_trade.cmobile,
                                :status=>:pending)
    service_order.tb_trade = tb_trade
    service_order.site = site
    service_order.save!
    tb_trade.service_order = service_order
    tb_trade.save!
    return service_order
  end

  def send_cancle site
    message_s = "服务预约取消:#{time_service.strftime("%F %H")}，客户:#{cname}，联系电话:#{cmobile},订单信息:"
    SmsWorker.new.perform site.phone,message_s
  end

  def send_assign_sms
  	message_s = "服务预约时间:#{time_service.strftime("%F %H")}，客户:#{cname}，联系电话:#{cmobile},订单信息:"  	
  	message_c = "#{cname}，服务预约时间:#{time_service.strftime("%F %H点")},#{site.summary}"
  	SmsWorker.new.perform site.phone,message_s
  	# SmsWorker.perform_async cmobile,message_c
    SmsWorker.new.perform cmobile,message_c
  end

end
