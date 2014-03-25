class SiteWorkersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_login
  MSG_TYPE={
    "text"     =>  do_text,  #why can't it find the do_text func
    "image"    =>  "fun_name",
    "voice"    =>  "fun_name",
    "video"    =>  "fun_name",
    "location" =>  "fun_name",
    "link"     =>  "fun_name",
    "event"    =>  "fun_name"
  }

  EVENT_TYPE={
    "subscribe"      =>  "fun_name",
    "unsubscribe"    =>  "fun_name",
    "SCAN"           =>  "fun_name",
    "LOCATION"       =>  "fun_name",
    "CLICK"          =>  "fun_name",
    "VIEW"           =>  "fun_name"
  }

  def wx_index
    render :text => params[:echostr]
  end
	
  def wx_create
    msg = params[:xml]
    fromUserName,toUserName = msg[:FromUserName],msg[:ToUserName]
    msg_type,create_time,mediaId,msgId = msg[:MsgType],Time.at(msg[:CreateTime].to_i),msg[:MediaId],msg[:MsgId]
    p MSG_TYPE[msg_type]
    #client = WeechatClient.get_instance "siteworker"
    #client.get_token if (client connect return 40001 which means the access_token is invalid)
    #client.download_media mediaId
  	@content = "hello site!"
    render :text,MSG_TYPE[msg_type]  #:formats => :xml   
  end



  private
  def check_weixin_legality
    array = ['gentek', params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end

  def do_text
    "~~#{params[:w]}--"
  end


end
