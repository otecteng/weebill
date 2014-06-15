class CreateWxTemplates < ActiveRecord::Migration
  def change
    create_table :wx_templates do |t|
      t.string :name
      t.string :menu_id
      t.string :ret_type
      t.text :ret_content
      t.integer :user_id

      t.timestamps
    end
  end
end
