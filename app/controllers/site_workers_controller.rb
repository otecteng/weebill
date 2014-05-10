class SiteWorkersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user!,:only=>[:wx_index,:wx_create,:new,:register]

  # before_filter :confirm_worker,:only=>[:on_event,:on_text,:on_image]

  def index
    @site_workers = SiteWorker.all
  end

  def new
    @site_worker = SiteWorker.new
    render layout:"m_form"
  end

  def edit
    @site_worker = SiteWorker.find(params[:id])
    @sites = current_user.sites
  end

  def destroy
    @obj = SiteWorker.find(params[:id])
    @obj.destroy
    redirect_to '/site_workers'
  end 

  def lock_worker
    @site_worker = SiteWorker.find(params[:id])
    @site_worker.update_attributes(:state=>"disable")
    redirect_to '/site_workers'
  end

  def update
    @site_worker = SiteWorker.find(params[:id])
    @site_worker.state = "enable"
    if @site_worker.update_attributes(params[:site_worker])
      redirect_to '/site_workers'
    else
      format.html { render action: "edit" }
    end
  end


  def register
    @site_worker = SiteWorker.create(params[:site_worker])
    render layout:"m_form"
  end


  def lock
    @site_worker = SiteWorker.create(params[:site_worker])
    render layout:"m_form"
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
      format.html { return render :text=>@content }
      format.xml { return render :text,:formats => :xml  }
    end
  end

  def on_text 
    return if !confirm_worker
    msg = params[:xml]
    content = msg[:Content]
    if @worker == content then
      SiteWorker.find_or_create_by_wid(msg[:FromUserName])
      @content = "ok registered!" # we need a reg session here
    else
      site_session_text
    end
  end

  def on_image 
    return if !confirm_worker
    @content = @worker.upload_image params[:xml][:MediaId]
  end

  def on_location 
    @content = ""
    render :text,:formats => :xml   
  end

  def on_link 
    @content = ""
    render :text,:formats => :xml   
  end       

  def on_event
    if params[:xml][:EventKey] =~ /^http/ then
      @content = "not support it"
    else
      args = params[:xml][:EventKey].split('_')
        case args[0]
        when "REGIST"
          @content = I18n.t("register") + '<a href="http://weebill.gps400.com/site_workers/new?wid='+params[:xml][:FromUserName]+'&user='+args[1]+'">register</a>'
        when "REPORT"
          @content = I18n.t("tip_upload_pix")+ "_" + args[1]
        end
    end 
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
      @worker = SiteWorker.find_or_create_by_wid(param[:FromUserName])
      unless @worker.site
        if param[:EventKey] == "reg" then
          @content = I18n.t("register")
        else
          @content = I18n.t("need_confirmed")
        end
      end
      return @worker.site
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
