require 'spec_helper'

describe User do
  it "import site excel file" do
  	subject.import_sites "site.xls"
  	site = subject.sites.first
  	site.name.should == ""
  	site.address.should == ""
  	site.contactor.should == ""
  	site.phone.should == ""

  end

  it "import tb_trade excel file" do
  	subject.import_tb_trade "trade.xls"
  	obj = subject.tb_trades.first
  	obj.time_trade.should == ""
  	obj.title.should == ""
  	obj.caddress.should == ""
  	obj.province.should == ""
  	obj.city.should == ""
  	obj.province.should == ""
  end
end
