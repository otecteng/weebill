class SiteWorker < ActiveRecord::Base
  attr_accessible :name, :nickname, :phone, :wid
end
