class SmsLogsController < ApplicationController
	def index
		@sms_logs = current_user.sms_logs.where("created_at >= ? ",DateTime.now - 7)
		respond_to do |format|
        	format.html 
        	format.json { render json: @sms_logs }
      	end
	end
end