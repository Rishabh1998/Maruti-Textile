class Item < ApplicationRecord
  belongs_to :section
  belongs_to :department
  belongs_to :division
  enum status: { active: 1, inactive: 2 }

end