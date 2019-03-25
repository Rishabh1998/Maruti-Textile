class CreateFillers < ActiveRecord::Migration[5.2]
  def change
    create_table :fillers do |t|
      t.references :party, foreign_key: true
      t.references :color, foreign_key: true
      t.float :quantity
      t.float :rate

      t.timestamps
    end
  end
end
