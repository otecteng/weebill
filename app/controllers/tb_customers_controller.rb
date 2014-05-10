class TbCustomersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_login

  def wx_index
    render :text => params[:echostr]
  end
	
  def wx_create
    msg = params[:xml]
    fromUserName,toUserName = msg[:FromUserName],msg[:ToUserName]
    msg_type,create_time,mediaId,msgId = msg[:MsgType],Time.at(msg[:CreateTime].to_i),msg[:MediaId],msg[:MsgId]
    self.send "on_#{msg_type}"
    return render :text,:formats => :xml  
    #respond_to do |format|
    #  format.html { render :text=>@content }
    #  format.xml { render :text,:formats => :xml  }

    #end
  end

  def on_text 
    msg = params[:xml]
    content = msg[:Content]
    if "1" == content then
      @content = "please fill form:http://weebill.gps400.com/service_orders/new_mobile.html"
    end
  end

  def on_link 
    @content = ""
    render :text,:formats => :xml   
  end

  def on_location 
    @content = ""
    render :text,:formats => :xml   
  end  

  private
  def check_weixin_legality
    array = ['gentek', params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end	
end

