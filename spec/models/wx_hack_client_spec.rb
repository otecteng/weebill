require 'spec_helper'

describe WxHackClient do
  it "can download media" do
  	client = WxHackClient.new("raymond_nj@163.com","xiaoer163")
  	p client.login
  end
end
