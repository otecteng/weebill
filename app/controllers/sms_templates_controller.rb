# encoding: utf-8
class SmsTemplatesController < ApplicationController
	def index
		@sms_templates = current_user.sms_templates
	end

	def new
		@sms_template = SmsTemplate.new
	end

	def create
		@sms_template = current_user.sms_templates.build(params[:sms_template])
		if @sms_template.save
  			redirect_to '/sms_templates'
  		else
  			render action: "new"
  		end
	end

	def edit
		@sms_template = SmsTemplate.find(params[:id])
	end

	def update
		@sms_template = SmsTemplate.find(params[:id])
		if @sms_template.update_attributes(params[:sms_template])
			redirect_to '/sms_templates'
		else
			format.html { render action: "edit" }
		end
	end

end
