require 'spec_helper'

describe User do
  subject {User.create(:name=>"wjj",:email=>"wjj@wjj.com",:password=>"wjj1q2w3e4r")}
  it "import site excel file" do
    p subject
  	subject.import_sites "sites.xls"
  	site = subject.sites.first
  	site.name.should == "小吴测试店"
  	site.address.should == "杭州"
  	site.contactor.should == "骚驴"
  	site.phone.should == "15216777879"

  end

  it "import tb_trade excel file" do
  	subject.import_tb_trades "trades.xls"
  	obj = subject.tb_trades.first
  	obj.time_trade.should == Date.new(2014,5,1)
    obj.cname.should=="文林杰"
    obj.tid.should=="635504583464207"
  	obj.title.should == "09年购买的宝来,导航+后视"
  	obj.caddress.should == "龙华新区民治街道朝阳新村19号401"
  	obj.cmobile.should == "18123915868 "
  	obj.city.should == "深圳"
  	obj.province.should == "广东"
  end
end
