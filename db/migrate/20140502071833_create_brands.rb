class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name
      t.string :description
      t.string :avatar
      t.integer :producer_id
      t.timestamps
    end
  end
end
