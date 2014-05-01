class AddUserToTbTrades < ActiveRecord::Migration
  def change
    add_column :tb_trades, :user_id, :integer
  end
end
