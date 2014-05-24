class SmsLog < ActiveRecord::Base
  belongs_to :user
  attr_accessible :amount, :message, :user_id
end
