class CreateTapes < ActiveRecord::Migration[5.2]
  def change
    create_table :tapes do |t|
      t.references :party, foreign_key: true
      t.string :type_name
      t.float :rate
      t.float :quantity

      t.timestamps
    end
  end
end
