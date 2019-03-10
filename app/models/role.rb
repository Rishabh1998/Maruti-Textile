class Role < ApplicationRecord

  # Associations
  has_many :user_roles, dependent: :restrict_with_exception
  has_many :users, through: :user_roles

  has_many :permission_roles, dependent: :restrict_with_exception
  has_many :permissions, through: :permission_roles

  # Accepts Nested Attributes
  accepts_nested_attributes_for :permissions

  # Validations
  validates :name, :description, presence: true
  validates :name, uniqueness: { case_sensitive: false, allow_blank: true }

  #scopes
  scope :active, -> { where(active: true) }
  scope :admin_only, -> { where(admin_only: true) }

end
