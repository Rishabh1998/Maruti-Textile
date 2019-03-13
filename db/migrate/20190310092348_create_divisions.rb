class CreateDivisions < ActiveRecord::Migration[5.2]
  def change
    create_table :divisions do |t|
      t.string :name
      t.integer :status

      t.timestamps
      t.index :name, unique: true
    end
  end
end
