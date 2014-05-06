 # encoding: utf-8
class Site < ActiveRecord::Base
  attr_accessible :address, :cert, :city, :contactor, :county, :location, :name, :province, :star,:alipay_account,:tencent_account,
  					:phone
  has_many :service_orders
  has_many :site_workers
  belongs_to :user
  
  def summary
  	"#{name},地址:#{address},电话:#{phone},联系人:#{contactor}"
  end
end
