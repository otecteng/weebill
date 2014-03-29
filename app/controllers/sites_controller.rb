class SitesController < ApplicationController

	def index
		p params
		@sites=Site.where("name like ? and province like ? and city like ?", "%#{params[:name] || ''}%","%#{params[:province] || ''}%", "%#{params[:city] || ''}%").paginate(:page => params[:page], :per_page => 10)
	end

	def add
		params.delete("controller")
		params.delete("action")
		@site=Site.new(params)
		if @site.save then
			render :json=>{:success=>true}
		else
			render :json=>{:success=>false}
		end
	end
end