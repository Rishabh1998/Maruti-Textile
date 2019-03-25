class CreateParties < ActiveRecord::Migration[5.2]
  def change
    create_table :parties do |t|
      t.string :name
      t.string :address
      t.string :mobile_number
      t.string :gstin
      t.float :rate
      t.float :weight

      t.timestamps
    end
  end
end
