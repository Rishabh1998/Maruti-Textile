class Admin::PermissionsController < ApplicationController
  before_action :authenticate_user
  before_action :only_allow_super_admin

  def index
    @permissions = Permission.all
  end
end

