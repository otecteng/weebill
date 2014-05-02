class BrandsController < ApplicationController
	def index
		@brands = Brand.all
	end

	def new

	end

	def create
	end

	def edit
		@brand = Brand.find(params[:id])
	end

	def update
		@brand = Brand.find(params[:id])		
		if @brand.update_attributes(params[:brand])
			redirect_to '/brands'
		else
			format.html { render action: "edit" }
		end
	end


	def destroy
		@obj = Brand.find(params[:id])
		@obj.destroy
		redirect_to '/brands'
	end	

end