class Brand < ActiveRecord::Base
  attr_accessible :description, :name,:avatar
  belongs_to :producer
  mount_uploader :avatar, AvatarUploader
end
