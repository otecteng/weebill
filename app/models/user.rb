class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :password, :phone, :username
  has_many :sites
  has_many :tb_trades
  has_many :service_orders
  
  def pay site,account
  	logger.info "#{user.name}--->pay--->#{site.name}---->#{account}"
  end
end
