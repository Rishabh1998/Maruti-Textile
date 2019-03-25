class CreateBobins < ActiveRecord::Migration[5.2]
  def change
    create_table :bobins do |t|
      t.references :party, foreign_key: true
      t.float :quantity
      t.float :rate

      t.timestamps
    end
  end
end
