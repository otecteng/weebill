class SiteWorker < ActiveRecord::Base
  attr_accessible :name, :nickname, :phone, :wid
  has_many :site_sessions

  def site_session
  	site_sessions.find{|s| s.status == "ON"}
  end

  def start_session
  	site_sessions.select{|s| s.status == "ON"}.each do |s|
  		s.status = 'OFF'
  		s.save!
  	end
  	site_sessions.create(:status => 'ON')
  end
end
