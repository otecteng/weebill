class AddCountyToTbTrade < ActiveRecord::Migration
  def change
    add_column :tb_trades, :county, :string
  end
end
