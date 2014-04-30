class SitesController < ApplicationController
	def index
		@sites=Site.all
	end

	def new
		@site = Site.new
	end

	def create
		@site = Site.new(params[:site])
		if @site.save
  			redirect_to '/sites'
  		else
  			render action: "new"
  		end
	end

	def edit
		@site = Site.find(params[:id])
	end

	def update
		@site = Site.find(params[:id])
		if @site.update_attributes(params[:site])
			redirect_to '/sites'
		else
			format.html { render action: "edit" }
		end
	end
end