class Offer < ApplicationRecord
  has_many :offer_items
  has_many :items, through: :offer_items
  accepts_nested_attributes_for :offer_items, allow_destroy: true

  enum status: { active: 1, inactive: 2 }
end