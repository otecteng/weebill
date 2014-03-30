class Site < ActiveRecord::Base
  attr_accessible :address, :cert, :city, :contactor, :county, :location, :name, :province, :star
  has_many :service_orders
  has_many :site_workers
end
