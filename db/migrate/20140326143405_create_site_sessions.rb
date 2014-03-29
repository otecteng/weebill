class CreateSiteSessions < ActiveRecord::Migration
  def change
    create_table :site_sessions do |t|
      t.integer :status 
      t.integer :site_worker_id
      t.string 	:pix
      t.string	:uid
      t.string  :state
      t.timestamps
    end
  end
end
