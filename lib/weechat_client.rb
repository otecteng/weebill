class WeechatClient
	@@client_customer
	@@client_siteworker
	def self.get_intance name
		if name == :client_customer then
			@@client_customer = WeechatClient.new ('','') if !@@client_customer
			return @@client_customer
		else
			@@client_siteworker = WeechatClient.new ('','') if !@@client_siteworker
			return @@client_siteworker
		end
	end

	def initialize appid,secret
		@appid = appid
		@secret = secret
		@access_token = nil
	end

	def download_media
		#http://file.api.weixin.qq.com/cgi-bin/media/get?access_token=ACCESS_TOKEN&media_id=MEDIA_ID
	end

	def send_message
	end
end