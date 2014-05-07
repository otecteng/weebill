 # encoding: utf-8
class ServiceOrder < ActiveRecord::Base
  attr_accessible :alipay_id, :alipay_pix, :cmobile, :cname, :price, :site_id, 
  					:site_pix, :site_worker_id, :status, :tb_trade_id, :uid, :user_id,
  					:time_service

  has_one :tb_trade
  belongs_to :site
  belongs_to :user


  state_machine :status, :initial => :pending do
    event :assign  do
      transition [:pending,:assigned]=>:assigned
    end
    event :install  do
      transition :assigned=>:installation
    end
    event :pay  do
      transition :installation=>:payed
    end
    event :cancle  do
      transition [:assigned,:installation]=>:cancled
    end
  end

  def send_sms
  	message_s = "服务预约时间:#{time_service.strftime("%F %H")}，客户:#{cname}，联系电话:#{cmobile},订单信息:"  	
  	message_c = "#{cname}，服务预约时间:#{time_service.strftime("%F %H点")},#{site.summary}"

  	SmsWorker.perform_async site.phone,message_s
  	SmsWorker.perform_async cmobile,message_c
    self.status = '已通知'
    self.save!
  end

end
