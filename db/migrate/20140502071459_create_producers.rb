class CreateProducers < ActiveRecord::Migration
  def change
    create_table :producers do |t|
      t.string :name
      t.string :description
      t.string :avatar
      t.timestamps
    end
  end
end
