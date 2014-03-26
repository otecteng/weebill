class WeechatClient
	@@client_customer = nil
	@@client_siteworker = nil
	HOST_API = 'https://api.weixin.qq.com'
	DOWNLOAD_DIR="/home/wjj/" #set the dir of the download file here
	MAP={
		"customer_appid"=>"wxea2ce7f47689a346",
		"customer_secret"=>"6768e51d3dbd253e264de342847067d2",
		"siteworker_appid"=>"",
		"siteworker_secret"=>""
	}

	CLIENT_MAP={
		"customer"=>@@client_customer,
		"siteworker"=>@@client_siteworker
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
	# def self.client_customer= customer_instance
	# 	@@client_customer=customer_instance
	# end
	
	def self.client_customer
		@@client_customer
	end

	# def self.client_siteworker= site_work_instance
	# 	@@client_siteworker=site_work_instance
	# end
	
	def self.client_siteworker
		@@client_siteworker
	end

	def self.get_instance name
		CLIENT_MAP[name] = WeechatClient.new name if !CLIENT_MAP[name]
		CLIENT_MAP[name]
	end

	def initialize type
		@appid = MAP["#{type}_appid"]
		@secret = MAP["#{type}_secret"]
		@access_token = nil
	end

    def get_api_token
      conn = Faraday.new(:url =>"http://file.api.weixin.qq.com") 
      response = conn.get "/cgi-bin/token?grant_type=client_credential" do |req|
        req.params['appid'] = @appid
        req.params['secret'] = @secret
      end
      @access_token = JSON.parse(response.body)["access_token"]
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
          fire_update = true
        end
    
        conn = Faraday.new(:url =>@@host_api) 
        response = conn.get url + "&access_token=#{@access_token}"
        ret = JSON.parse(response.body)
        if ret["errcode"] then #expired
          p ret
          if "42001"==ret["errcode"] then
            return nil unless get_api_token
            response = conn.get url + "&access_token=#{@access_token}"
            fire_update = true
          else
            return nil
          end
        end
        @update_block.call(@access_token) if (@update_block and fire_update)
        return ret 
    end

	def api_post(url,body)
	    get_api_token unless @access_token
	    conn = Faraday.new(:url => @@host_api)
	    response = conn.post "#{URL_ADVANCED[url]}?access_token=#{@access_token}" do |req|
	      req.body = body
	    end
	    p response.body
	    return (JSON.parse(response.body)["errcode"] == 0)
	end
	def download_media media_id
		res=api_get(:media,{"media_id"=>media_id})
		open("#{DOWNLOAD_DIR}#{res.headers["content-disposition"].split("\"")[1]}","w+"){ |f| f.write(res.body)} if res	
	end

	def send_message
	end


end