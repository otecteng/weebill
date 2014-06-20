# encoding: utf-8
class ReportsController < ApplicationController
  def trades
  	# [{x:1,y:1},{x:2,y:2},{x:3,y:3}]
	ret = TbTrade.where("created_at > ?",DateTime.now - 30).order(:created_at).group("DATE(created_at)").count.map{|k,v| {x:k.to_time.to_i*1000,y:v}}	
    respond_to do |format|
      format.json {render :json => ret}
    end
  end	
end