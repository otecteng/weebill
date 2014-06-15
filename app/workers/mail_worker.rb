 # encoding: utf-8
class MailWorker
  include Sidekiq::Worker
  def perform(username,password,fan,subject,msg)
    begin
      mail = Mail.new do
        from     username
        to       fan
        subject  subject#'Here is the image you wanted'
        body     msg#File.read('body.txt')
        #add_file :filename => 'somefile.png', :content => File.read('/somefile.png')
        delivery_method :smtp, { 
          :address => "smtp.163.com",
          :port => "25",
          :domain => '163.com',
          :authentication => :login,
          :user_name => username,
          :password => password,
          :enable_starttls_auto => true
        }    
      end
      mail.deliver
    rescue=>e
      #logger.info "mail send faild,#{username}"
      #logger.info e 
      return false
    end
    return true
  end
end