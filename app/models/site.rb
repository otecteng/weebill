 # encoding: utf-8
class Site < ActiveRecord::Base
  attr_accessible :address, :cert, :city, :contactor, :county, :location, :name, :province, :star,:alipay_account,:tencent_account,
  					:phone
  has_many :service_orders
  has_many :site_workers
  belongs_to :user
  MAP={:name=>"名称",:address=>"地址",:contactor=>"联系人",:phone=>"电话"}

  def self.import user,file_name
  	s = case file_name.split(".").last 
      when "xls"
        Roo::Excel.new(file_name)
      when "xlsx"
        Roo::Excelx.new("myspreadsheet.xlsx")
      end
  	site_list=[]
  	s.each(MAP){|hash| site_list << hash}
  	site_list.shift
  	site_list.each {|site| user.sites.build(site).save}
  end
  
  def summary
  	"#{name},地址:#{address},电话:#{phone},联系人:#{contactor}"
  end
end
