class SiteWorkersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_login
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
