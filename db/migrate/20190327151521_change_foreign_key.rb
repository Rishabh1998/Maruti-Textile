class ChangeForeignKey < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :types, :colors
    add_foreign_key :types, :colors, on_delete: :cascade
    remove_foreign_key :plastic_scraps, :parties
    add_foreign_key :plastic_scraps, :parties, on_delete: :cascade
    remove_foreign_key :plastic_scraps, :types
    add_foreign_key :plastic_scraps, :types, on_delete: :cascade
    remove_foreign_key :fillers, :parties
    add_foreign_key :fillers, :parties, on_delete: :cascade
    remove_foreign_key :fillers, :colors
    add_foreign_key :fillers, :colors, on_delete: :cascade
    remove_foreign_key :bobins, :parties
    add_foreign_key :bobins, :parties, on_delete: :cascade
    remove_foreign_key :gittis, :parties
    add_foreign_key :gittis, :parties, on_delete: :cascade
    remove_foreign_key :tapes, :parties
    add_foreign_key :tapes, :parties, on_delete: :cascade
    remove_foreign_key :thellies, :parties
    add_foreign_key :thellies, :parties, on_delete: :cascade
    remove_foreign_key :daanas, :parties
    add_foreign_key :daanas, :parties, on_delete: :cascade
    remove_foreign_key :daanas, :types
    add_foreign_key :daanas, :types, on_delete: :cascade
  end
end
