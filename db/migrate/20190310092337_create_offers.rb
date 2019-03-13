class CreateOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :offers do |t|
      t.string :name
      t.string :description
      t.integer :status

      t.timestamps
      t.index [:name, :status]
    end
  end
end
