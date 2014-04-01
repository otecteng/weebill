class User < ActiveRecord::Base
  attr_accessible :name, :password, :phone, :username
  def pay site,account
  	logger.info "#{user.name}--->pay--->#{site.name}---->#{account}"
  end
end
