 # encoding: utf-8

require 'spec_helper'

describe WeechatClient do
  it "can download media" do
    w = WeechatClient.get_instance :siteworker
    w.download_media "fnP1Zz83aNFrm24kvqRCaJ638Qf1wD3P0hZY0-C8aroyNtNy2-wKdvenvFEPfrYL"
    #confirm the media is downloaded!
  end

  it "can update menu" do
  	w = WeechatClient.get_instance :siteworker
  	p w.api_get_menu

	menu = {
	    "button"=>
	    [
			{"type" => "click","name"=> "REG","key"=> "REGIST_1"},
			{"type" => "click","name"=> "REPORT","key"=> "REPORT_1"},
	    ]
	}
	p w.api_set_menu menu
  end
end
