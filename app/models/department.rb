class Department < ApplicationRecord
  has_many :items
  enum status: { active: 1, inactive: 2 }
end