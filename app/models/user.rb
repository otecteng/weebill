class User < ActiveRecord::Base
  attr_accessible :name, :password, :phone, :username
end
