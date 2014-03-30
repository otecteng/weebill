class SiteWorker < ActiveRecord::Base
  attr_accessible :name, :nickname, :phone, :wid,:wuid
  belongs_to :site
  has_many :site_sessions

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
end
