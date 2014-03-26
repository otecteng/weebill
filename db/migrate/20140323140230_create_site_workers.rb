class CreateSiteWorkers < ActiveRecord::Migration
  def change
    create_table :site_workers do |t|
      t.string :wid
      t.string :wuid
      t.string :nickname
      t.string :name
      t.string :phone

      t.timestamps
    end
  end
end
