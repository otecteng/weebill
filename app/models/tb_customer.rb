class TbCustomer < ActiveRecord::Base
  attr_accessible :blacklist, :city, :county, :mobile, :name, :nickname, :province
end
