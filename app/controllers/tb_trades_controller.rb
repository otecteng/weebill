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
		if @tb_trade.update_attributes(params[:tb_trade])
			if(@tb_trade.status=="error" && (@tb_trade.confirm_address || @tb_trade.city))
				ServiceOrder.create_from_trade(@tb_trade)
				@tb_trade.status = "assigned"
				@tb_trade.save
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
		trade = TbTrade.find params[:id]
		@service_order = ServiceOrder.create_from_trade trade
		redirect_to service_order_path(@service_order)
	end	
end