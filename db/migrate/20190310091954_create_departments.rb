class CreateDepartments < ActiveRecord::Migration[5.2]
  def change
    create_table :departments do |t|
      t.string :name
      t.integer :status

      t.timestamps
      t.index :name, unique: true
    end
  end
end
