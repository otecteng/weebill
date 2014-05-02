class Site < ActiveRecord::Base
  attr_accessible :address, :cert, :city, :contactor, :county, :location, :name, :province, :star,:alipay_account,:tencent_account,
  					:phone
  has_many :service_orders
  has_many :site_workers
<<<<<<< HEAD

  def self.import file_name
 #  	s = Roo::OpenOffice.new("myspreadsheet.ods")       loads an OpenOffice Spreadsheet
	# s = Roo::Excel.new("myspreadsheet.xls")            loads an Excel Spreadsheet
	# s = Roo::Google.new("myspreadsheetkey_at_google")  loads a Google Spreadsheet
	# s = Roo::Excelx.new("myspreadsheet.xlsx")          loads an Excel Spreadsheet for Excel .xlsx files
	#s = Roo::CSV.new("mycsv.csv") 
  	s = Roo::Excel.new(file_name)
  	site_list=[]
  	s.each(:name=>"name",:city=>"city"){|hash| site_list << hash}
  	site_list.shift
  	site_list.each {|site| Site.create(site)}
  end
=======
  belongs_to :user
>>>>>>> ec49c9da64c1f26eff819aaed9665a91ffd5c050
end
