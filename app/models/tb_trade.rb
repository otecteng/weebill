# encoding: utf-8
class TbTrade < ActiveRecord::Base
  default_scope order('created_at DESC')

  attr_accessible :memo, :num_iid, :price, :status, :tb_customer_id, :tid, :title,
  					:time_trade,:cname,:cmobile,:cadddress,:province,:city

  has_one :service_order 
  belongs_to :user	
  scope :status, lambda {|status| where(:status => status)}
  
  def summary
  	"客户:#{cname},电话:#{cmobile},地址:#{cadddress}"
  end

end
