class SmsLogsController < ApplicationController
	def index
		@sms_logs = current_user.sms_logs
		respond_to do |format|
        	format.html 
        	format.json { render json: @sms_logs }
      	end
	end
end