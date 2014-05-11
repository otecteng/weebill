class TbTradesController < ApplicationController
	def index
		@tb_trades = current_user.tb_trades
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
			redirect_to '/tb_trades'
		else
			format.html { render action: "edit" }
		end
	end

	def destroy
		@obj = TbTrade.find(params[:id])
		@obj.destroy
		redirect_to '/tb_trades'
	end	

	def import
	end

	def upload
		file_name="#{Rails.root}/public/uploads/tb_trades/#{Time.now.strftime('%Y%m%d%H%M%S')}-#{params[:file]['file'].original_filename}"
		File.open(file_name, "wb") { |f| f.write(params[:file]['file'].read) }
		current_user.import_tb_trades file_name		
		redirect_to '/tb_trades'
	end

	def assign
		trade = TbTrade.find params[:id]
		@service_order = ServiceOrder.create_from_trade trade
		redirect_to service_order_path(@service_order)
	end	
end