 # encoding: utf-8
class SmsWorker
  include Sidekiq::Worker
  def perform(user_id,fans,msg)
    ChinaSMS.use :smsbao, username: 'raymond_nj', password: '88888888'
    x = ChinaSMS.to fans,msg
    p x # ChinaSMS.message
  end  
end