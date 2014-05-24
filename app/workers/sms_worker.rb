 # encoding: utf-8
class SmsWorker
  include Sidekiq::Worker
  def perform(user_id,fans,msg)
    ChinaSMS.use :smsbao, username:Setting.sms_user, password:Setting.sms_password
    # ret = ChinaSMS.to fans,msg
    ret={:success=>true}
    SmsLog.create(:user_id=>user_id,:message=>msg,:amount=>(msg.length/64).ceil) if ret[:success]
  end  
end