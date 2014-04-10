class TbTradesController < ApplicationController
	def index
		@tb_trades = TbTrade.all
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
		@obj = TbTrade.new(params[:tb_trade])
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
end