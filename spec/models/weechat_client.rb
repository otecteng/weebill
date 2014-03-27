require 'spec_helper'

describe WeechatClient do
  it "can download media" do
    w = WeechatClient.get_instance "customer"
    w.download_media '123'
    #confirm the media is downloaded!
  end
end
