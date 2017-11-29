class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.string :title , null: false, default: ""
      t.text :text
      t.string :username , null: false, default: ""
      t.string :tel 
      t.string :email , null: false, default: ""
      t.string :company
      t.string :address

      t.timestamps
    end
  end
end
