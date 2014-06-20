# encoding: utf-8
class TbTrade < ActiveRecord::Base
  attr_accessible :memo, :num_iid, :price, :status, :tb_customer_id, :tid, :title,
  					:time_trade,:cname,:cmobile,:cadddress,:province,:city,:county

  has_one :service_order 
  belongs_to :user	
  scope :status, lambda {|status| where(:status => status)}
  
  def summary
  	"客户:#{cname},电话:#{cmobile},地址:#{cadddress}"
  end

  def address
  	"#{province}-#{city}-#{county}"
  end

  def confirm_address
  	begin
      args = Site.confirm_region(cadddress)
      if args then
        self.update_attributes(:province=>args[0],:city=>args[1],:county=>args[2],:status=>"pending")
        return true
      else
        self.update_attributes(:status=>"error")
       	if cadddress[0..2] =~ /北京|天津|上海/ then
            a2 = cadddress[2..-1].split(/区/)[0]
            if city = Region.get_region(a2)
              self.update_attributes(:province=>city["father"]["name"],:city=>city["father"]["name"],:county=>city["name"],:status=>"pending")
              return true
            end            
        end
      end
    rescue=>e
      self.update_attributes(:status=>"error")
      return false
    end
    return false
  end

end
