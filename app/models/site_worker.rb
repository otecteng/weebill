 # encoding: utf-8

class SiteWorker < ActiveRecord::Base
  attr_accessible :name, :nickname, :phone, :wid,:wuid,:site_id,:state,
                  :picture_uploaded
  belongs_to :site
  has_many :site_sessions
  has_many :sessions
  
  def site_session
  	site_sessions.find{|s| s.status == 1}
  end

  def start_session
  	site_sessions.select{|s| s.status == 1}.each do |s|
  		s.status = 0
  		s.save!
  	end
  	site_sessions.create(:status => 1)
  end

  def upload_image media_id
    self.update_attributes(:picture_uploaded=>media_id)
    site.service_orders.map{|o|
      "#{o.cname}:<a hef=\"http://weebill.goxplanet.com/service_orders/#{o.id}/fill?worker=#{id}&site=#{site.id}\">完成</a>"
    }.join(" , ") 
  end
end
