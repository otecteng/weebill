class SiteSession < ActiveRecord::Base
  attr_accessible :site_worker_id,:status,:pix,:uid
  belongs_to :site_worker
end
