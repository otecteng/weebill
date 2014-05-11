require 'faraday'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
class WeixinObject
  def initialize(params = nil)
    if params
    params.each { |var,val| self.send "#{var}=", val if self.class.instance_methods.include?(var.to_sym)}
    end
  end

  def to_hash
    hash = {}
    instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var) if var.to_s != "@id" }
    hash
  end
end

class WeixinMessage < WeixinObject
  attr_accessor :id,:type,:fakeid,:nick_name,:date_time,:content,:source,:msg_status,:has_reply,:refuse_reason

  def filePath
    file_type = {"2"=>"jpg","3"=>"mp3","4"=>"mp4"}[@type]
    "#{@id}.#{file_type}"
  end

  def fileType
    filetype={"2"=>"image/jpg","3"=>"audio/mp3","4"=>"video/mp4"}[@type]
  end
end

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
    pwd = Digest::MD5.hexdigest(@password)
    params = {"username"=>@username,"pwd"=>pwd,"imgcode"=>'',"f"=>'json'} 
    ret = request(:post,URL_LIST[:login],params,referer(:login))
    return 'login failed' if !ret.headers["set-cookie"] 
    ret.headers["set-cookie"].split(',').each do |c|
      @cookie << c.split(';')[0] <<";"
    end
    msg = JSON.parse(ret.body)["redirect_url"]
    @token = msg[msg =~ /token/..-1].split('=')[1]
    ret = request(:get,URL_LIST[:home],{},@@host)
    return ret.status.to_s
  end

  def get_messages(lastmsgid=0,count=20)
    return if !@cookie && login(@username,@password) =~ /failed/
    lastmsgid = lastmsgid ||= 0
    ret,offset =[], 0
    loop do
      res = request(:get,"#{URL_LIST[:messages]}&offset=#{offset}&count=#{count}&day=7&f=json",{},nil)
      messages = JSON(JSON.parse(res.body)["msg_items"])["msg_item"].map {|m| WeixinMessage.new(m)} 
      break if messages.length == 0
      if messages[-1].id <= lastmsgid
        idx = messages.index{|m| m.id == lastmsgid}
        messages = messages[0,idx]
      end
      ret = ret + messages
      offset = offset + count
    end
    ret
  end

  def avatar_download(file,url)
    ret = request(:get,url,{},nil)
    File.open("#{file}jpg", 'wb') { |fp| fp.write(ret.body) }
  end

  def download_file(message)
    url="/cgi-bin/downloadfile?msgid=#{message.id}&source="
    avatar_download(message.filePath,url)
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
      end
    end
  rescue=>e
    p "**************->>>>>wrong"
    return nil
  end
    ret
  end

  def referer(url)
    "#{@@host}#{URL_LIST[url]}"
  end  
end

