 # encoding: utf-8
class SmsWorker
  include Sidekiq::Worker
  def perform(fans,msg)
    # ChinaSMS.use :smsbao, username: 'raymond_nj', password: '88888888'
    # x = ChinaSMS.to fans,msg
    # p x # ChinaSMS.message
    p "send sms #{fans} #{msg}"
  end  
end