class CreatePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :permissions do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.string :description

      t.timestamps
    end
    add_index :permissions, :code,         unique: true
  end
end
