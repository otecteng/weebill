class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :password, :phone, :username
  has_many :sites
  has_many :tb_trades
  has_many :service_orders
  
  def pay site,account
  	logger.info "#{user.name}--->pay--->#{site.name}---->#{account}"
  end

  def import_sites
  end

  def import_tb_trades
  end

private
  def read file_name,map
  s = case file_name.split(".").last 
      when "xls"
        Roo::Excel.new(file_name)
      when "xlsx"
        Roo::Excelx.new("myspreadsheet.xlsx")
     end
    s.default_sheet = s.sheets.last
    tb_trade_list = s.parse(map)
    tb_trade_list.shift
  end
end
