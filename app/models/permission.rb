class Permission < ApplicationRecord

  # Associations
  has_many :permission_roles
  has_many :roles, through: :permission_roles

  # Validations
  validates :name, :code, presence: true
  validates :name, :code, uniqueness: { case_sensitive: false, allow_blank: true }

end
