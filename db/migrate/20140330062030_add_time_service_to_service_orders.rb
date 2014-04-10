class AddTimeServiceToServiceOrders < ActiveRecord::Migration
  def change
    add_column :service_orders, :time_service, :datetime
  end
end
