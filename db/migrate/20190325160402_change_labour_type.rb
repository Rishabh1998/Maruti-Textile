class ChangeLabourType < ActiveRecord::Migration[5.2]
  def change
    change_column :plastic_scraps, :labour, :integer
  end
end
