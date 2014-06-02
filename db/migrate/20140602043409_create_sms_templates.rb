class CreateSmsTemplates < ActiveRecord::Migration
  def change
    create_table :sms_templates do |t|
      t.string :title
      t.string :sms_type
      t.text :content
      t.string :signature
      t.integer :user_id

      t.timestamps
    end
  end
end
