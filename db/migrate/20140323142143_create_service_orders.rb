class CreateServiceOrders < ActiveRecord::Migration
  def change
    create_table :service_orders do |t|
      t.string :cname
      t.string :cmobile
      t.integer :site_id
      t.integer :tb_trade_id
      t.string :status
      t.float :price
      t.string :site_pix
      t.integer :site_worker_id
      t.integer :user_id
      t.string :uid
      t.string :alipay_id
      t.string :alipay_pix

      t.timestamps
    end
  end
end
