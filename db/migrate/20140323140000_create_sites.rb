class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.string :address
      t.string :contactor
      t.string :location
      t.string :province
      t.string :city
      t.string :county
      t.string :star
      t.integer :cert

      t.timestamps
    end
  end
end
