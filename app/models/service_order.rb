class ServiceOrder < ActiveRecord::Base
  attr_accessible :alipay_id, :alipay_pix, :cmobile, :cname, :price, :site_id, 
  					:site_pix, :site_worker_id, :status, :tb_trade_id, :uid, :user_id,
  					:time_service
  has_one :tb_trade
  belongs_to :site
  belongs_to :user
end
