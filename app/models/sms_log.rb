class SmsLog < ActiveRecord::Base
  default_scope order('created_at DESC')
  belongs_to :user
  attr_accessible :amount, :message, :user_id,:recv,:status
end
