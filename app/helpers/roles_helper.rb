module RolesHelper
  def permissions_for_select
    Permission.pluck(:name, :id).to_a
  end

  def roles_for_select
    Role.pluck(:name, :id).to_a
  end
end
