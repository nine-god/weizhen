class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
      t.string :class_type
      t.integer :class_type_id
      t.string :name
      t.longtext :data
	  
	  t.references :article, foreign_key: false
	  t.references :product, foreign_key: false
      t.timestamps
    end
  end
end
