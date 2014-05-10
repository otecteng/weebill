class AddMemoToServiceOrder < ActiveRecord::Migration
  def change
    add_column :service_orders, :memo, :string
  end
end
