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
		if params[:time_service] then
	      	args_date = params[:time_service][:time_date].split('-').map{|i| i.to_i}
	      	args_time_hour = params[:time_service][:time_time][:hour].to_i
	      	args_time_minute = params[:time_service][:time_time][:minute].to_i
			@obj.time_service = DateTime.new(args_date[0],args_date[1],args_date[2],args_time_hour,args_time_minute)
		end
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

	def new_mobile
		@service_order = ServiceOrder.new
		render :layout=>false
	end
end