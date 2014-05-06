class AddSiteToSiteWorkers < ActiveRecord::Migration
  def change
    add_column :site_workers, :site_id, :integer
    add_column :site_workers, :state, :string
    add_column :site_workers, :picture_uploaded, :string
  end
end
