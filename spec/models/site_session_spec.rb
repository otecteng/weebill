require 'spec_helper'
require 'site_session'

describe SiteSession do
  pending "add some examples to (or delete) #{__FILE__}"
  
  it "print normal flow" do
    order = ServiceOrder.create()
    subject.site_worker = SiteWorker.create(:name=>'teng')
  	subject.state.should == "pending"
  	subject.image :MediaId=>"123"
  	subject.state.should == "pix_uploaded"
  	subject.text :Content=>order.id.to_s
  	subject.state.should == "complished"
  end

  xit "print bad flow" do
  	subject.state.should == "pending"
  	p subject.text :Content=>"321"
  	p subject.image :MediaId=>"123"
  end  
end
