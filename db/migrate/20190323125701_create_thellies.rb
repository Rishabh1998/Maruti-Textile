class CreateThellies < ActiveRecord::Migration[5.2]
  def change
    create_table :thellies do |t|
      t.references :party, foreign_key: true
      t.float :weight
      t.float :rate
      t.float :quantity

      t.timestamps
    end
  end
end
