class CreateSmsLogs < ActiveRecord::Migration
  def change
    create_table :sms_logs do |t|
      t.integer :user_id
      t.string :message
      t.integer :amount

      t.timestamps
    end
  end
end
