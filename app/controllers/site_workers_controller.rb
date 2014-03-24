class SiteWorkersController < ApplicationController

	def index 
		render json: Site.all
	end

end
