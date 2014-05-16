 # encoding: utf-8
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
  SITE_MAP={:name=>"名称",:address=>"地址",:contactor=>"联系人",:phone=>"电话",:province=>"省",:city=>"市",:cert=>"星级"}
  TB_TRADE_MAP={:time_trade=>"日期",:tid=>"订单号",:cname=>"姓名",:cmobile=>"联系方式",:cadddress=>"车主所在地",:title_header=>"车型",:title_footer=>"安装明细"}
  def pay site,account
  	logger.info "#{user.name}--->pay--->#{site.name}---->#{account}"
  end

  def import_sites file_name
    read(file_name,SITE_MAP).each do |site|
      site[:phone]=site[:phone].to_i if site[:phone]
      sites.create(site)
    end 
  end

  def import_tb_trades file_name
    time_base = Date.new(1900,1,1)
    read(file_name,TB_TRADE_MAP).each do |tb_trade|
      tb_trade[:cname].gsub!(/ /,"") unless tb_trade[:cname].blank?
      tb_trade[:time_trade] = time_base+tb_trade[:time_trade].to_i-2 if tb_trade[:time_trade]
      tb_trade[:title] = "#{tb_trade[:title_header] || '无车型信息'},#{tb_trade[:title_footer] || '无安装信息'}"
      tb_trade[:cmobile] = tb_trade[:cmobile].to_i if tb_trade[:cmobile]
      tb_trade[:cadddress] = tb_trade[:cadddress] if tb_trade[:cmobile]
      tb_trade.delete :title_header
      tb_trade.delete :title_footer
      db_trade = tb_trades.create(tb_trade)
      begin
        if tb_trade[:cadddress][0..2] =~ /北京|天津|上海/ then
          a2 = tb_trade[:cadddress][2..-1].split(/区/)[0]
          if city = Site.confirm_city(a2)
            db_trade.update_attributes(:province=>city[:province],:city=>city[:city],:status=>"pending")
          else
            db_trade.update_attributes(:status=>"error")
          end
        else
          addr = tb_trade[:cadddress].gsub!(/ /,"").split(/省|市|自治区/,3) unless tb_trade[:cadddress].blank?
          if addr && addr.length>2 && city = Site.confirm_city(addr[1]) then
            db_trade.update_attributes(:province=>city[:province],:city=>city[:city],:status=>"pending")
          else
            db_trade.update_attributes(:status=>"error")
          end
        end
        # p tb_trade[:cadddress]
      rescue=>e
        db_trade.update_attributes(:status=>"error")
        p e
      end
    end
  end

private
  def read file_name,map
    s = case file_name.split(".").last 
        when "xls"
          Roo::Excel.new(file_name)
        when "xlsx"
          Roo::Excelx.new(file_name)
    end
    s.default_sheet = s.sheets.last
    x = s.parse(map)
    tb_trade_list = x
    tb_trade_list.shift
    tb_trade_list
  end
end
