require 'faraday'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
class WxHackClient
  @@host = 'https://mp.weixin.qq.com'
  URL_LIST = {
    :login    => "/cgi-bin/login",
    :home     => "/cgi-bin/home?t=home/index",
    :advance  =>"/cgi-bin/advanced?action=dev&t=advanced/dev",
    :messages =>"/cgi-bin/message?t=message/list",
    :fans     =>"/cgi-bin/contactmanage?t=user/index",

    :filepage =>"/cgi-bin/filepage?t=media/list",
    :service  =>"/cgi-bin/store?action=index&t=service/index",
    :settings =>"/cgi-bin/settingpage?t=setting/index&action=index",
    :mode_dev =>"/cgi-bin/advanced?action=dev&t=advanced/dev",
    :mode_switch=>"/cgi-bin/skeyform?form=advancedswitchform",
    :talk   =>"/cgi-bin/singlesendpage?t=message/send",
    :contact  =>"/cgi-bin/getcontactinfo?t=ajax-getcontactinfo",
    :callback =>"/cgi-bin/callbackprofile?t=ajax-response",
    :appmsg_r =>"/cgi-bin/appmsg?t=media/appmsg_list&action=list",    
    :appmsg_w =>"/cgi-bin/operate_appmsg",
    :send_single   =>"/cgi-bin/singlesend?t=ajax-response",
    :send_mass     =>"/cgi-bin/masssend?t=ajax-response",
    :fans_edit=>"/cgi-bin/modifycontacts",
    :avatar_w =>"/cgi-bin/filetransfer?action=upload_material"
  }
  

  def initialize(username,password)
    @username = username
    @password = password
    @cookie = ""
    @conn = Faraday.new(url:'https://mp.weixin.qq.com',headers: { accept_encoding: 'none' })
    @conn_multipart = Faraday.new(url:'https://mp.weixin.qq.com',headers: { accept_encoding: 'none' }) do |faraday|
      faraday.request :multipart
      faraday.adapter :net_http      
    end
  end
  
  def login(username=nil,password=nil)
    @username = username if username
    @password = password if password
    puts "login with #{@username}-------#{@password}"
    pwd = Digest::MD5.hexdigest(@password)

    params = {"username"=>@username,"pwd"=>pwd,"imgcode"=>'',"f"=>'json'} 
    ret = request(:post,URL_LIST[:login],params,referer(:login))
    return 'login failed' if !ret.headers["set-cookie"] 
    ret.headers["set-cookie"].split(',').each do |c|
      @cookie << c.split(';')[0] <<";"
    end
    p ret.body
    msg = JSON.parse(ret.body)["redirect_url"]
    p msg
    @token = msg[msg =~ /token/..-1].split('=')[1]
    p @token
    ret = request(:get,URL_LIST[:home],{},@@host)
    return ret.status.to_s
  end

  def request(method,url,params,referer)
    @conn.headers["Cookie"] = @cookie
    @conn.headers["Referer"] = referer if referer
    begin
    #https://mp.weixin.qq.com/cgi-bin/login?lang=zh_CN
    if method == :post then
      ret = @conn.post do |req|
        req.url url
        req.body = params
        req.body['token'] = @token if @token
      end
    else
      ret = @conn.get do |req|
        url = "#{url}&token=#{@token}&lang=zh_CN"
        @conn.params = params
        req.url url
        p "========#{url}==========>"
        p @conn
      end
    end
  rescue=>e
    p e
    p "**************->>>>>wrong"
    return nil
  end
    ret
  end

  def referer(url)
    "#{@@host}#{URL_LIST[url]}"
  end  
end

