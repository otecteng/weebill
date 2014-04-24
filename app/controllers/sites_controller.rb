class SitesController < ApplicationController
	def index
		@sites=Site.all
		# @sites = Site.where("name like ? and province like ? and city like ?", "%#{params[:name] || ''}%","%#{params[:province] || ''}%", "%#{params[:city] || ''}%").paginate(:page => params[:page], :per_page => 10)
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