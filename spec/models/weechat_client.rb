require 'spec_helper'

describe WeechatClient do
  it "can download media" do
    w = WeechatClient.get_instance :siteworker
    w.download_media "fnP1Zz83aNFrm24kvqRCaJ638Qf1wD3P0hZY0-C8aroyNtNy2-wKdvenvFEPfrYL"
    #confirm the media is downloaded!
  end
end
