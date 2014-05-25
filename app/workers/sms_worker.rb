 # encoding: utf-8
class SmsWorker
  include Sidekiq::Worker
  def perform(user_id,fans,msg)
    ChinaSMS.use :smsbao, username:Setting.sms_user, password:Setting.sms_password
    ret = ChinaSMS.to fans,msg
    sms = SmsLog.create(:recv=>fans,:user_id=>user_id,:message=>msg,:amount=>(msg.length/64).ceil) # if ret[:success]
    sms.status = ret[:success]
    sms.save!
  end  
end