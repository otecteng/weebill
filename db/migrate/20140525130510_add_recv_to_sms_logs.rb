class AddRecvToSmsLogs < ActiveRecord::Migration
  def change
    add_column :sms_logs, :recv, :string
    add_column :sms_logs, :status, :string
  end
end
