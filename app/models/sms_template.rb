class SmsTemplate < ActiveRecord::Base
  attr_accessible :content, :signature, :title, :sms_type, :user_id
  scope :sms_type, lambda {|sms_type| where(:sms_type => sms_type)}
end
