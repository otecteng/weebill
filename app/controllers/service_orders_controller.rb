class ServiceOrdersController < ApplicationController

	def index
		if params[:site_id] then
			@service_orders = ServiceOrder.where(:site_id=>params[:site_id].to_i)
		else
			@service_orders = ServiceOrder.all
		end

	end

	def new
		@service_order = ServiceOrder.new
	end

	def create
		@obj = ServiceOrder.new(params[:service_order])
  		if @obj.save
  			redirect_to '/service_orders'
  		else
  			render action: "new"
  		end
	end

	def update
		@obj = ServiceOrder.find(params[:id])
		if @obj.update_attributes(params[:service_order])
			redirect_to '/service_orders'
		else
			format.html { render action: "edit" }
		end
	end
	
	def destroy
		@obj = ServiceOrder.find(params[:id])
		@obj.destroy
		redirect_to '/service_orders'
	end

end