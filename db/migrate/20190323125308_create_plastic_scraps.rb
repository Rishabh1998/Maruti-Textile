class CreatePlasticScraps < ActiveRecord::Migration[5.2]
  def change
    create_table :plastic_scraps do |t|
      t.references :party, foreign_key: true
      t.references :type, foreign_key: true
      t.float :rate
      t.float :weight
      t.float :delhi_weight
      t.float :bhiwani_weight
      t.float :bags_quantity
      t.string :bardana
      t.string :labour

      t.timestamps
    end
  end
end
