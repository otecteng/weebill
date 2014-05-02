 # encoding: utf-8
class Site < ActiveRecord::Base
  attr_accessible :address, :cert, :city, :contactor, :county, :location, :name, :province, :star,:alipay_account,:tencent_account,
  					:phone
  has_many :service_orders
  has_many :site_workers
  belongs_to :user

  def self.import file_name
  	s = Roo::Excel.new(file_name)
  	site_list=[]
  	s.each(:name=>"name",:city=>"city"){|hash| site_list << hash}
  	site_list.shift
  	site_list.each {|site| Site.create(site)}
  end
  
  def summary
  	"#{name},地址:#{address},电话:#{phone},联系人：#{contactor}"
  end
end
