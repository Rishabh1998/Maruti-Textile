class CreateOfferItems < ActiveRecord::Migration[5.2]
  def change
    create_table :offer_items do |t|
      t.integer :offer_id
      t.integer :item_id

      t.timestamps
      t.index :offer_id
    end
  end
end
