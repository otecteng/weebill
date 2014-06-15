class AddMailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mail_account, :string
    add_column :users, :mail_password, :string
  end
end
