 # encoding: utf-8
class TbTrade < ActiveRecord::Base
  attr_accessible :memo, :num_iid, :price, :status, :tb_customer_id, :tid, :title,:time_trade,:cname,:cmobile,:caddress,:province,:city

  has_one :service_order 
  belongs_to :user	


end
