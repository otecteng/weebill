class ServiceOrdersController < ApplicationController

	def index
		if params[:site_id] then
			@service_orders = ServiceOrder.where(:site_id=>params[:site_id].to_i)
		else
			@service_orders = current_user.service_orders
		end
	end

	def new
		@service_order = ServiceOrder.new
		if params[:id_tb_trade] then
			trade = TbTrade.find params[:id_tb_trade]
			@service_order.cname = trade.cname
			@service_order.cmobile = trade.cmobile
			@service_order.tb_trade_id = trade.id
		end
	end

	def create
		@obj = current_user.service_orders.build(params[:service_order])

		@obj.price = 0
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
	
	def edit
		@service_order = ServiceOrder.find(params[:id])
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
	
	def show
		@service_order = ServiceOrder.find(params[:id])
	end

	def new_mobile
		@service_order = ServiceOrder.new
		render :layout=>false
	end

	def confirm_pay
		@obj = ServiceOrder.find(params[:id])
		@obj.update_attributes(:status=>'PAID')
		current_user.pay(@obj.site,price)
	end

	def send_sms
		@obj = ServiceOrder.find(params[:id])
		@obj.send_sms 
		redirect_to '/service_orders'
	end

end