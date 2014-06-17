 # encoding: utf-8

class SiteWorker < ActiveRecord::Base
  default_scope order('created_at DESC')
  
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
  end

  def download_image
    return "" if !picture_uploaded
    w = WeechatClient.get_instance :siteworker
    w.download_media picture_uploaded
    return "/downloads/#{picture_uploaded}.jpg"
  end

end
