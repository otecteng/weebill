class SiteWorkersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_login

  def wx_index
    render :text => params[:echostr]
  end
	
  def wx_create
    msg = params[:xml]
    fromUserName,toUserName = msg[:FromUserName],msg[:ToUserName]
    msg_type,create_time,mediaId,msgId = msg[:MsgType],Time.at(msg[:CreateTime].to_i),msg[:MediaId],msg[:MsgId]
    self.send "on_#{msg_type}",msg
  end



  def on_text param
    content = param[:Content]
    if "reg" == content then
      SiteWorker.find_or_create_by_wid(param[:FromUserName])
      @content = "ok registered!" # we need a reg session here
    else
      worker = SiteWorker.find_by_wid(param[:FromUserName])
      if !worker then
        @content = "sorry, no worker,  use reg to regsiter"
      else
        if "st" == content then
          @content = "upload your pix,session = #{worker.start_session.id}!"
        else
          if !worker.site_session then
            @content = "no session avaliable, input st to start a session"
          else
            if worker.site_session.pix.blank? then
              @content = "pls upload pix first !"
            else
              service_order = ServiceOrder.find(param[:Content].to_i)
              if !service_order then
                @content = "bad service order id , check again?"
              else
                service_order.update_attributes（:site_worker_id=>worker.id, :site_pix=>worker.site_session.pix,:status=>"SUBMITTED")
                worker.site_session.update_attributes(:uid => param[:Content],:status =>"OFF")
                @content = "session  done!bill: #{worker.site_session.pix}-#{service_order.id}"
              end
            end
          end
        end
      end
    end
    render  :xml => {:ToUserName=>param[:FromUserName],:FromUserName=>param[:ToUserName],:CreateTime=>Time.now.to_i,:MsgType=>"text",:Content=>@content}.to_xml(:root=> "xml")     
  end

  def on_image param
    worker = SiteWorker.find_by_wid(params[:FromUserName])
    if worker then
      if worker.site_session then
        client = WeechatClient.get_instance "siteworker"
        client.download_media param[:MediaId]
        worker.site_session.update_attributes(:pix => param[:MediaId])
        @content = "pix upload ok,pls fill bill id,session = #{worker.site_session.id}!"
      else
        @content = "no session avaliable, input st to start a session"
      end
    else
        @content = "sorry, not reg , refused" 
    end      
    @content = "hello site!"
    render :text , :formats => :xml   
  end

  def on_location param
    content = param[:Content]
  end

  def on_link param
    content = param[:Content]
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
end
