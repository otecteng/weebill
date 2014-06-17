# encoding: utf-8
class TbTradesController < ApplicationController
	def index
		@tb_trades = current_user.tb_trades
		@tb_trades = @tb_trades.status(params[:status]) if params[:status]

		respond_to do |format|
        	format.html 
        	format.json { render json: @tb_trades }
      	end
	end
	
	def new
		@tb_trade = TbTrade.new
	end
	def edit
		@tb_trade = TbTrade.find(params[:id])
		flash[:notice] = "用户手机解析错误，请检查后重填" unless @tb_trade.cmobile =~ /^(1(([385][0-9])|(47)|[8][01236789]))\d{8}$/
	end

	def create
		@obj = current_user.tb_trades.build(params[:tb_trade])
  		if @obj.save
  			redirect_to '/tb_trades'
  		else
  			render action: "new"
  		end
	end
	
	def update
		@tb_trade = TbTrade.find(params[:id])
		if params[:tb_trade][:cmobile] then
			params[:tb_trade][:cmobile] = params[:tb_trade][:cmobile].gsub(' ',"")
			unless params[:tb_trade][:cmobile] =~ /^(1(([385][0-9])|(47)|[8][01236789]))\d{8}$/
			  flash[:notice] = "用户手机解析错误，请检查后重填"
			  return redirect_to :back			 	
			end 
		end
		if @tb_trade.update_attributes(params[:tb_trade])
			if(@tb_trade.confirm_address)
			  if service_order = @tb_trade.service_order
			  	site = current_user.find_site(@tb_trade)
			  	service_order.set_site(site)
			  else
			  	service_order = ServiceOrder.create_from_trade(@tb_trade) 
			  end
			  #@tb_trade.status = service_order.site ? "assigned" : "pending"
			  @tb_trade.status = "assigned"
			  @tb_trade.save
			else
			  flash[:notice] = "地址解析错误，请检查后重填"
			  return redirect_to :back
			end
			ret = current_user.tb_trades.status('error').length > 0 ? '/tb_trades/error' : '/service_orders'
			redirect_to ret
		else
			format.html { render action: "edit" }
		end
	end

	def destroy
		@obj = TbTrade.find(params[:id])
		@obj.destroy
		redirect_to '/tb_trades'
	end	

	def error
		@tb_trades = current_user.tb_trades.status('error')
		render :action=>"index"
	end

	def import
	end
	def delete_all
		@objs = TbTrade.where(:id =>params[:ids])
		@objs.delete_all
		redirect_to :back
	end
	def upload
		file_name="#{Rails.root}/public/uploads/trades#{Time.now.strftime('%Y%m%d%H%M%S')}-#{params[:file]['file'].original_filename}"
		File.open(file_name, "wb") { |f| f.write(params[:file]['file'].read) }
		current_user.import_tb_trades file_name
		ret = current_user.tb_trades.status('error').length > 0 ? '/tb_trades/error' : '/service_orders'
		redirect_to ret
	end

	def assign
		@trade = TbTrade.find params[:id]
		@trade.status = "error"
		# @trade.service_order.delete if @trade.service_order && (!@trade.service_order.assigned?)
		@trade.save
		redirect_to :back
	end	
end