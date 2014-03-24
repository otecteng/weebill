class SiteWorkersController < ApplicationController
  def index
    render :text => params[:echostr]
  end
	
  def create
  	@content = "hello site!"
    render :text,:formats => :xml   
  end

  private
  def check_weixin_legality
    array = ['gentek', params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end	
end
