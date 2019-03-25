class CreateTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :types do |t|
      t.string :name
      t.references :color, foreign_key: true, on_delete: :cascade
      t.string :description

      t.timestamps
    end
  end
end
