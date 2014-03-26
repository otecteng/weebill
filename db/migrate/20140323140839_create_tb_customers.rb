class CreateTbCustomers < ActiveRecord::Migration
  def change
    create_table :tb_customers do |t|
      t.string :name
      t.string :mobile
      t.string :province
      t.string :city
      t.string :county
      t.string :nickname
      t.boolean :blacklist
      t.string :wid
      t.string :wuid
      t.timestamps
    end
  end
end
