# encoding: utf-8
class WxTemplatesController < ApplicationController
	def index
		@wx_templates = current_user.wx_templates
	end

	def new
		@wx_template = WxTemplate.new
	end

	def create
		@wx_template = current_user.wx_templates.build(params[:wx_template])
		if @wx_template.save
  			redirect_to '/wx_templates'
  		else
  			render action: "new"
  		end
	end

	def edit
		@wx_template = WxTemplate.find(params[:id])
	end

	def update
		@wx_template = WxTemplate.find(params[:id])
		if @wx_template.update_attributes(params[:wx_template])
			redirect_to '/wx_templates'
		else
			format.html { render action: "edit" }
		end
	end

end
