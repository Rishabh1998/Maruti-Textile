class User < ApplicationRecord
  include Permissible
  enum status: { active: 1, inactive: 2 }
  enum user_type: { admin: 1, normal:2, super_admin: 3 }
  enum preference: { all_modules: 1, grocery:2, food: 3 }

  #EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  validates :email, :presence => true, :uniqueness => true
  validates_length_of :password, :in => 6..20, :on => :create

  before_save :encrypt_password
  after_save :clear_password

  has_many :user_roles, dependent: :restrict_with_exception
  has_many :roles, through: :user_roles
  accepts_nested_attributes_for :roles


  def permissions
    Permission.joins(:permission_roles).where(permission_roles: { role_id: role_ids })
  end

  def permission_codes
    @_user_permissions_codes ||= permissions.pluck(:code)
  end

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.password= BCrypt::Engine.hash_secret(password, salt)
    else
      self.password = password_was
    end

  end

  def clear_password
    self.password = nil
  end

  def self.authenticate(email="", login_password="")
    user = User.find_by(email: email, status: 'active')

    if user && user.match_password(login_password)
      return user
    else
      return false
    end
  end

  def match_password(login_password="")
    password == BCrypt::Engine.hash_secret(login_password, salt)
  end

end
