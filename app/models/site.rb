 # encoding: utf-8
class Site < ActiveRecord::Base
  include RooHelper
  attr_accessible :address, :cert, :city, :contactor, :county, :location, :name, :province, :star,:alipay_account,:tencent_account,
  					:phone
  has_many :service_orders
  has_many :site_workers
  belongs_to :user

  MAP={:name=>"名称",:address=>"地址",:contactor=>"联系人",:phone=>"电话"}

  def self.import user,file_name
  	(read file_name,MAP).each {|site| user.sites.create(site)}
  end
  
  def summary
  	"#{name},地址:#{address},电话:#{phone},联系人:#{contactor}"
  end
end
