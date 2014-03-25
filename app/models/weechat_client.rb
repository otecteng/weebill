class WeechatClient
	@@client_customer = nil
	@@client_siteworker = nil

	MAP={"customer_appid"=>"wxea2ce7f47689a346","customer_secret"=>"6768e51d3dbd253e264de342847067d2","siteworker_appid"=>"","siteworker_secret"=>""}

	CLIENT_MAP={"customer"=>@@client_customer,"siteworker"=>@@client_siteworker}

	def self.client_customer= customer_instance
		@@client_customer=customer_instance
	end
	
	def self.client_customer
		@@client_customer
	end

	def self.client_siteworker= site_work_instance
		@@client_siteworker=site_work_instance
	end
	
	def self.client_siteworker
		@@client_siteworker
	end

	def self.get_instance name
		CLIENT_MAP[name] = WeechatClient.new name if !CLIENT_MAP[name]
		return CLIENT_MAP[name]
	end

	def initialize type
		@appid = MAP["#{type}_appid"]
		@secret = MAP["#{type}_secret"]
		@access_token = nil
	end

    def get_token
      conn = Faraday.new(:url =>"http://file.api.weixin.qq.com") 
      response = conn.get "/cgi-bin/token?grant_type=client_credential" do |req|
        req.params['appid'] = @appid
        req.params['secret'] = @secret
      end
      @access_token = JSON.parse(response.body)["access_token"]
    end

	def download_media media_id
		url="http://file.api.weixin.qq.com/cgi-bin/media/get?access_token=#{@access_token}&media_id=#{media_id}"
	end

	def send_message
	end
end