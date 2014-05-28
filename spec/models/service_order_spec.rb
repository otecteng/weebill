require 'spec_helper'
require 'site_session'

describe ServiceOrder do
  pending "add some examples to (or delete) #{__FILE__}"
  
  xit "print normal flow" do
    site = Site.create(name:'beicai',phone:'13761270749')
    tb_trade = TbTrade.create()
    service_order = ServiceOrder.create(cname:"teng",cmobile:'18621976853',time_service:Time.now)
    service_order.site = site
  	service_order.send_sms 
  end

  xit "print bad flow" do
  	subject.state.should == "pending"
  	p subject.text :Content=>"321"
  	p subject.image :MediaId=>"123"
  end  

  xit "print bad flow" do
    subject.state.should == "pending"
    p subject.text :Content=>"321"
    p subject.image :MediaId=>"123"
  end  

end
