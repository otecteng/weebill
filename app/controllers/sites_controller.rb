class SitesController < ApplicationController
	def index
		@sites = current_user.sites
	end

	def new
		@site = Site.new
	end

	def create
		@site = current_user.sites.build(params[:site])
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

	def import
	end

	def upload
		file_name="#{Rails.root}/public/upload/#{Time.now.strftime('%Y%m%d%H%M%S')}-#{params[:file]['file'].original_filename}"
		File.open(file_name, "wb") { |f| f.write(params[:file]['file'].read) }
		Site.import file_name
		@sites=Site.all
		render action: "index" 
	end

	def destroy
		@obj = Site.find(params[:id])
		@obj.destroy
		redirect_to '/sites'
	end	

end