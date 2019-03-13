class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.integer :division_id
      t.integer :section_id
      t.integer :department_id
      t.string  :company_name
      t.string  :category
      t.string :name
      t.float :mrp
      t.float :discount
      t.float :rsp
      t.float :standard_rate
      t.string :barcode
      t.string :item_hsn_description
      t.string :item_code
      t.string :item_hsn_code
      t.boolean :display
      t.integer :status

      t.timestamps
      t.index :name, unique: true
    end
  end
end
