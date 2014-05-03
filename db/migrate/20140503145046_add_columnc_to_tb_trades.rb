class AddColumncToTbTrades < ActiveRecord::Migration
  def change
    add_column :tb_trades, :province, :string
    add_column :tb_trades, :city ,  :string
  end
end
