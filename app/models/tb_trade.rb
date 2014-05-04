 # encoding: utf-8
class TbTrade < ActiveRecord::Base
  attr_accessible :memo, :num_iid, :price, :status, :tb_customer_id, :tid, :title,:time_trade,:cname,:cmobile,:caddress,:province,:city

  has_one :service_order 
  belongs_to :user	
  MAP={:time_trade=>"日期",:tid=>"订单号",:cname=>"姓名",:cmobile=>"联系方式",:caddress=>"车主所在地",:title_header=>"车型",:title_footer=>"安装明细"}

  def self.import user,file_name
  	s = case file_name.split(".").last 
      when "xls"
        Roo::Excel.new(file_name)
      when "xlsx"
        Roo::Excelx.new("myspreadsheet.xlsx")
      end
    s.default_sheet = s.sheets.last
  	tb_trade_list = s.parse(MAP)
  	tb_trade_list.shift
  	time_base = Date.new(1900,1,1)
  	tb_trade_list.each do |tb_trade| 
  		tb_trade[:time_trade]=time_base+tb_trade[:time_trade].to_i-2 if tb_trade[:time_trade]
  		tb_trade[:title]="#{tb_trade[:title_header] || '无车型信息'},#{tb_trade[:title_footer] || '无安装信息'}"
      tb_trade[:cmobile]=tb_trade[:cmobile].to_i if tb_trade[:cmobile]
  		addr=tb_trade[:caddress].split(/省|市|自治区/,3) if tb_trade[:caddress] 
  		tb_trade[:province],tb_trade[:city],tb_trade[:caddress]=*addr if addr && addr.length==3 
  		tb_trade.delete :title_header
  		tb_trade.delete :title_footer
  		user.tb_trades.build(tb_trade).save
  	end
  end


end
