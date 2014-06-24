class AddTimePayToServiceOrders < ActiveRecord::Migration
  def change
    add_column :service_orders, :time_pay, :datetime
  end
end
