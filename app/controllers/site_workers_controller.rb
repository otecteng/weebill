class SiteWorkersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user!,:only=>[:wx_create]

  before_filter :confirm_worker,:only=>[:site_session_text,:on_image]

  def index
    @site_workers = SiteWorker.all
  end

  def wx_index
    p params[:echostr]
    render :text => params[:echostr]
  end
	
  def wx_create
    msg = params[:xml]
    fromUserName,toUserName = msg[:FromUserName],msg[:ToUserName]
    msg_type,create_time,mediaId,msgId = msg[:MsgType],Time.at(msg[:CreateTime].to_i),msg[:MediaId],msg[:MsgId]
    self.send "on_#{msg_type}"
    respond_to do |format|
      format.html { render :text=>@content }
      format.xml { render :text,:formats => :xml  }
    end
  end

  def on_text 
    msg = params[:xml]
    content = msg[:Content]
    if "reg" == content then
      SiteWorker.find_or_create_by_wid(msg[:FromUserName])
      @content = "ok registered!" # we need a reg session here
    else
      site_session_text
    end
  end

  def on_image 
    return unless confirm_worker
    param = params[:xml]
    return unless confirm_session
    current_session.image param
    @content = current_session.message
  end

  def on_location 
    @content = ""
    render :text,:formats => :xml   
  end

  def on_link 
    @content = ""
    render :text,:formats => :xml   
  end       

  def site_session_text 
    return unless confirm_worker
    param = params[:xml]
    if "st" == param[:Content] then
      @worker.start_session
      @content = @worker.site_session.message
    else
      return unless confirm_session
      current_session.text param
      @content = current_session.message 
    end
  end

  # def send_text msg
  #   client=WeechatClient.get_instance "siteworker"
  #   client.send_message msg
  # end
  private
    def check_weixin_legality
      array = ['gentek', params[:timestamp], params[:nonce]].sort
      render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
    end

    def confirm_worker 
      param = params[:xml]
      @worker = SiteWorker.find_by_wid(param[:FromUserName])
      @content = "sorry, not reg , refused" unless @worker
      @worker 
    end

    def confirm_session
      if !@worker.site_session then
        @content = "no session avaliable, input st to start a session"
      end
      @current_session = @worker.site_session
    end
    def current_session
      @current_session
    end
end
