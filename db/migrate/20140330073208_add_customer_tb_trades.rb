class AddCustomerTbTrades < ActiveRecord::Migration
  def change
    add_column :tb_trades, :time_trade, :datetime
    add_column :tb_trades, :cname, :string
    add_column :tb_trades, :cmobile, :string
    add_column :tb_trades, :cadddress, :string
    add_column :tb_trades, :service_order_id, :integer
  end
end
