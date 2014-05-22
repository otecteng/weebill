# encoding: utf-8
class ServiceOrdersController < ApplicationController
	skip_before_filter :authenticate_user!,:only=>[:fill_m,:install_m]

	def index
		if params[:site_id] then
			@service_orders = ServiceOrder.where(:site_id=>params[:site_id].to_i)
		else
			@service_orders = current_user.service_orders
		end
		@service_orders=@service_orders.status(params[:status]) if params[:status]
	end

	def new
		@service_order = ServiceOrder.new
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
		site_old = @obj.site.clone if @obj.site
		if @obj.update_attributes(params[:service_order])
			if params[:time_service] then
		      	args_date = params[:time_service][:time_date].split('-').map{|i| i.to_i}
		      	args_time_hour = params[:time_service][:time_time][:hour].to_i
		      	args_time_minute = params[:time_service][:time_time][:minute].to_i
				@obj.time_service = DateTime.new(args_date[0],args_date[1],args_date[2],args_time_hour,args_time_minute)
				@obj.save!
			end
			if @obj.status == "pending" && @obj.site then
			  @obj.assign site_old, @obj.site
			end
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

	def inform
		@obj = ServiceOrder.find(params[:id])
		@obj.inform 
		redirect_to '/service_orders'
	end

	# def send_sms
	# 	@obj = ServiceOrder.find(params[:id])
	# 	@obj.assign 
	# 	redirect_to '/service_orders'
	# end

	def install
		@service_order = ServiceOrder.find(params[:id])
		@service_order.install
		redirect_to :back
	end

	def pay
		@service_order = ServiceOrder.find(params[:id])
		@service_order.pay
		current_user.pay(@obj.site,price)
		redirect_to :back
	end

	def fill_m
		@service_order = ServiceOrder.find(params[:id])
	    render layout:"m_form"
	end

	def install_m
		@service_order = ServiceOrder.find_by_uid(params[:service_order][:uid])
		if @service_order then
		# @service_order.update_attributes(params[:service_order])
			@service_order.install
			@message = "服务预约号识别成功<p>辛苦啦，我们将尽快完成确认"
		else
			@message = "无效的服务预约号"
		end
	    render layout:"m_form"
	end
	
	def delete_all
		@objs = ServiceOrder.where(:id =>params[:ids])
		@objs.delete_all
		redirect_to :back
	end
end