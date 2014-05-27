 # encoding: utf-8
class SmsWorker
  include Sidekiq::Worker
  def perform(user_id,fans,msg)
  	vendor = Setting.sms_vendor.to_sym
  	if vendor == :yunpian
  		ChinaSMS.use :yunpian, password:Setting.sms_password
  		ret = ChinaSMS.to fans,msg
    else
	    ChinaSMS.use vendor, username:Setting.sms_user, password:Setting.sms_password
    	ret = ChinaSMS.to fans,msg
    end
    sms = SmsLog.create(:recv=>fans,:user_id=>user_id,:message=>msg,:amount=>(msg.length/64.0).ceil) # if ret[:success]
    sms.status = ret[:msg]
    sms.save!
  end  
end