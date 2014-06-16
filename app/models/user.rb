 # encoding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:mail_account,:mail_password
  attr_accessible :name, :password, :phone, :username
  has_many :sites
  has_many :tb_trades
  has_many :service_orders
  has_many :sms_logs
  has_many :sms_templates
  has_many :wx_templates

  SITE_MAP={:name=>"店名",:address=>"地址",:contactor=>"联系人",:phone=>"电话"} #,:cert=>"星级"
  TB_TRADE_MAP={:time_trade=>"日期",:tid=>"订单号",:cname=>"姓名",:cmobile=>"联系方式",:cadddress=>"车主所在地",:title_header=>"车型",:title_footer=>"安装明细"}

  def pay site,account
  	logger.info "#{name}--->pay--->#{site.name}---->#{account}"
  end

  def import_sites file_name
    read(file_name,SITE_MAP).each do |site|
      site[:phone] = site[:phone].to_i if site[:phone]
      if site[:address] && addr = Site.confirm_region(site[:address])
        site[:province],site[:city],site[:county]=addr[0],addr[1],addr[2]
      else
        site[:star]="*"
      end
      sites.create(site)
    end 
  end

  def import_tb_trades file_name
    time_base = Date.new(1900,1,1)
    read(file_name,TB_TRADE_MAP).each do |tb_trade|
      begin
        tb_trade[:cname].gsub!(/ /,"") unless tb_trade[:cname].blank?
        # tb_trade[:time_trade] = time_base + tb_trade[:time_trade].to_i-2 if tb_trade[:time_trade]
        tb_trade[:title] = "#{tb_trade[:title_header] || '无车型信息'},#{tb_trade[:title_footer] || '无安装信息'}"
        cmobile = tb_trade[:cmobile]
        if tb_trade[:cmobile] then
          tb_trade[:cmobile] = tb_trade[:cmobile].to_i.to_s if tb_trade[:cmobile].is_a?(Float) || tb_trade[:cmobile].is_a?(Integer)
          tb_trade[:cmobile] = tb_trade[:cmobile].split(/ | |,|，/).map{|i| i.gsub(' ',"")}.select{|x| x =~ /^(1(([35][0-9])|(47)|[8][01236789]))\d{8}$/}.first          
        end
        tb_trade[:cadddress] = tb_trade[:cadddress] if tb_trade[:cmobile]
        tb_trade[:cadddress].gsub! '北京北京','北京'
        tb_trade[:cadddress].gsub! '重庆重庆','重庆'
        tb_trade[:cadddress].gsub! '上海上海','上海'
        tb_trade[:cadddress].gsub! '天津天津','天津'
        tb_trade.delete :title_header
        tb_trade.delete :title_footer
        next if tb_trades.find_by_tid(tb_trade[:tid])
        db_trade = tb_trades.create(tb_trade)
        if db_trade[:cmobile]
          db_trade.confirm_address
        else          
          db_trade.update_attributes(:status=>"error",:cmobile=>cmobile)
        end
      rescue Exception => e
        logger.info e
        logger.info tb_trade
      end
    end
    tb_trades.status("pending").each do |tb_trades|
      ServiceOrder.create_from_trade(tb_trades)
    end
  end

  def find_site tb_trade
    ret = nil
    if tb_trade.city then
      if tb_trade.county then
        ret = sites.county(tb_trade.city,tb_trade.county).first
        return ret if ret
        city = Region.get_region(tb_trade.city)
        regions = sites.city(tb_trade.city).uniq{|x| x.tb_trade.county}.map{ |s| {site:s,region:Region.get_region(s.county,city)}}
        region = Region.get_region(tb_trade.county,city)
        region = regions.sort{|x,y| x[:region].distance_to(region)<=>y[:region].distance_to(region)}.first
        if region
          return region[:site]
        end
      end
      ret ||= sites.city(tb_trade.city).first
    end
  end

  def send_sms_mail reciever,sms # a trick , we send sms by mail
    MailWorker.perform_async(mail_account,mail_password,reciever,sms.signature,sms.content)
  end

  def confirm_trade trade,worker
    service_order = trade.service_order
    if service_order then
      service_order.install
      worker.download_image
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
