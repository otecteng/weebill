class AddPayToSite < ActiveRecord::Migration
  def change
    add_column :sites, :alipay_account, :string
    add_column :sites, :caifu_account, :string
  end
end
