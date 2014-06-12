# encoding: utf-8

require 'spec_helper'

describe User do
  it "import site excel file" do 
    user = User.create(:email=>"wjj@wjj.com",:password=>"password",:password_confirmation=>"password")   
  	user.import_sites "/Users/tli/Downloads/航睿安装点每日更新(2).xlsx"
  	(user.sites-user.sites.need_update).each do |s|
      p s.summary_address
    end
    p "user.sites.length = #{user.sites.length}"
    p "bad user.sites.length = #{user.sites.need_update.length}"
    user.sites.need_update.each{|x| p x.address}
  end

  it "import tb_trade excel file" do
    user = User.create(:email=>"lt@wjj.com",:password=>"password",:password_confirmation=>"password") 
  	user.import_tb_trades "/Users/tli/Downloads/x.xlsx"
  	p user.tb_trades.length
    p user.tb_trades.status("error").length
    user.tb_trades.status("pending").each{|x| p x.address}


  	# obj.time_trade.strftime("%Y%m%d").should == Date.new(2014,5,1).strftime("%Y%m%d")
   #  obj.cname.should=="文林杰"
   #  obj.tid.should==635504583464207
  	# obj.title.should == "09年购买的宝来,导航+后视"
  	# obj.caddress.should == "龙华新区民治街道朝阳新村19号401"
  	# obj.cmobile.should == "18123915868"
  	# obj.city.should == "深圳"
  	# obj.province.should == "广东"
    # p obj.inspect
  end

  it "find nearest site" do
    user = User.create(:email=>"wjj@wjj.com",:password=>"password",:password_confirmation=>"password")   
    user.sites.create(:province=>"上海市",:city=>"上海市",:county=>"浦东新区",:location=>"{lng:121.638481,lat: 31.230895}")
    user.sites.create(:province=>"上海市",:city=>"上海市",:county=>"黄浦区",:location=>"{lng: 121.496072,lat: 31.227203}")
    # user.sites.create(:province=>"上海市",:city=>"上海市",:county=>"长宁区",:location=>{"lng: 121.387616，lat: 31.213301}")
    tb_trade = user.tb_trades.create(:province=>"上海市",:city=>"上海市",:county=>"长宁区")
    p user.find_site(tb_trade)
  end
end
