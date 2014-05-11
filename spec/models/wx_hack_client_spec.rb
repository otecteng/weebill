require 'spec_helper'

describe WxHackClient do
  it "can download media" do
  	client = WxHackClient.new("raymond_nj@163.com","xiaoer163")
  	p client.login
  	msg = client.get_messages
  	# p msg
  	p msg[-2].inspect
  	p client.download_file(msg[-2])
  end
end
