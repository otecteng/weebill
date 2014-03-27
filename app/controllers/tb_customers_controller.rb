class TbCustomersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_login
  def wx_index
    render :text => params[:echostr]
  end
	
  def wx_create
  	p "===========>"
  	@content = "hello c!"
    render :text,:formats => :xml   
  end

  private
  def check_weixin_legality
    array = ['gentek', params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end	
end



'<xml><FromUserName>from</FromUserName><ToUserName>to</ToUserName><MsgType>text</MsgType><Content>reg</Content></xml>'