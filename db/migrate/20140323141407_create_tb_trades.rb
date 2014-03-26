class CreateTbTrades < ActiveRecord::Migration
  def change
    create_table :tb_trades do |t|
      t.integer :tid, :limit=>8
      t.string :num_iid
      t.integer :tb_customer_id
      t.string :title
      t.string :price
      t.string :status
      t.text :memo

      t.timestamps
    end
  end
end
