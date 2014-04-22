class Site < ActiveRecord::Base
  attr_accessible :address, :cert, :city, :contactor, :county, :location, :name, :province, :star,:alipay_account,:tencent_account
  has_many :service_orders
  has_many :site_workers
end
