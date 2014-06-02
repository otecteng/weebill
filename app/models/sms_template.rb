class SmsTemplate < ActiveRecord::Base
  attr_accessible :content, :signature, :title, :sms_type, :user_id
end
