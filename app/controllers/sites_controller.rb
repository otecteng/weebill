class SitesController < ApplicationController
	def index
		p params
		@sites = Site.where("name like ? and province like ? and city like ?", "%#{params[:name] || ''}%","%#{params[:province] || ''}%", "%#{params[:city] || ''}%").paginate(:page => params[:page], :per_page => 10)
	end

	def add
		params.delete("controller")
		params.delete("action")
		@site = Site.new(params)
		if @site.save then
			redirect_to '/sites'
		else
			render :json=>{:success=>false}
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