require 'faraday'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
class WeechatClient
	@@host_api = 'https://api.weixin.qq.com'
	@@client_customer = nil
	@@client_siteworker = nil
	HOST_API = 'https://api.weixin.qq.com'
	DOWNLOAD_DIR="/home/tli" #set the dir of the download file here

	@CLIENTS = {}
	CLIENT_MAP={
		:customer => @@client_customer,
		:siteworker => @@client_siteworker
	}

	URL_ADVANCED = {
	    :user_info  => "/cgi-bin/user/info",
	    :menu       => "/cgi-bin/menu/create",
	    :menu_get   => "/cgi-bin/menu/get",
	    :user_list  => "/cgi-bin/user/get",
	    :group_list => "/cgi-bin/groups/get",
	    :user_change_group => "/cgi-bin/groups/members/update",
	    :send => "/cgi-bin/message/custom/send",
	    :media => "/cgi-bin/media/get"
  	}

	def self.get_instance name
	  @CLIENTS[name] ||= WeechatClient.new(Setting["#{name}_appid".to_sym],Setting["#{name}_secret".to_sym])
	end

	def initialize (appid,secret)
		@appid = appid
		@secret = secret
		@access_token = nil
	end

	def download_media media_id
		res = api_get(:media,{"media_id"=>media_id})
		open("#{DOWNLOAD_DIR}#{res.headers["content-disposition"].split("\"")[1]}","w+"){ |f| f.write(res.body)} if res	
	end

	def send_message body
		res = api_post(:send,body)
		p res
	end

	def api_set_menu(menu)
	  api_post(:menu,menu.to_json.gsub!(/\\u([0-9a-z]{4})/) {|s| [$1.to_i(16)].pack("U")})
	end

	def api_get_menu
	  data = api_get(:menu_get)
	end

    def api_get_user_list(next_openid=nil)
      args = {}
      args = {next_openid:next_openid} if next_openid
      data = api_get(:user_list,args)
      return nil unless data
      data["data"]["openid"]
    end

    def api_get(url,args={})
        fire_update = false
        url = "#{URL_ADVANCED[url]}?"
        args.each{|k,v| url = url + "&#{k.to_s}=#{v.to_s}"}
    
        if !@access_token then
          get_api_token
          return nil unless @access_token
        end
    
        conn = Faraday.new(:url =>@@host_api) 
        req = url + "&access_token=#{@access_token}"
        p req
        response = conn.get req
        ret = JSON.parse(response.body)
        p ret
        if ret["errcode"] then #expired
          if "42001"==ret["errcode"] then
            return nil unless get_api_token
            response = conn.get url + "&access_token=#{@access_token}"
          else
            return nil
          end
        end
        return ret 
    end

	def api_post(url,body)
	    get_api_token unless @access_token
	    conn = Faraday.new(:url => @@host_api)
		response = conn.post "#{URL_ADVANCED[url]}?access_token=#{@access_token}" do |req|
		    req.body = body
		end
		# if JSON.parse(response.body)["errcode"]=="42001" then
		#     @access_token = nil
		#     redo
		# end 
	    return response
	end

    def get_api_token
      conn = Faraday.new(:url =>@@host_api) 
      p @appid
      p @secret
      response = conn.get "/cgi-bin/token?grant_type=client_credential" do |req|
        req.params['appid'] = @appid
        req.params['secret'] = @secret
      end
      p response.body
      @access_token = JSON.parse(response.body)["access_token"]
    end

end

