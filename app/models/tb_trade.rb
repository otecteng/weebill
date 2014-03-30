class TbTrade < ActiveRecord::Base
  attr_accessible :memo, :num_iid, :price, :status, :tb_customer_id, :tid, :title,
  				:time_trade,:cname,:cmobile,:caddress

  belongs_to :service_order 				
end
