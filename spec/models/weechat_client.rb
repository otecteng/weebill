 # encoding: utf-8

require 'spec_helper'

describe WeechatClient do
  it "can download media" do
    w = WeechatClient.get_instance :siteworker
    w.download_media "qdAn-N0eMjnieTxaqEEWg0-7K4QEiSBBvnDhybWal9wqNyij7kipDjIovzMzWX1F"
    #confirm the media is downloaded!
  end

  it "can update menu" do
  	w = WeechatClient.get_instance :siteworker
  	p w.api_get_menu
  	menu = {
      button:[
      {
        name:"产品系列",
        sub_button:[
        {  
            type:"click",
            name:"DVD导航",
            key:"m_0"
        },{
            type:"click",
            name:"安卓智能导航",
            key:"m_0"
        },{
            type:"click",
            name:"4S店合作",
            key:"m_0"
        }]
      },{
        type:"click",
        name:"地图升级",
        key:"m_2"
      },{
        name:"售后服务",
        sub_button:[
        {  
            type:"click",
            name:"厂商通道",
            key:"m_3"
        },{
            type:"click",
            name:"4S店合作",
            key:"m_0"
        }]
      }]
  	}
 	p w.api_set_menu menu
  end
end
