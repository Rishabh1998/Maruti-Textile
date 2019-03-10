class Admin::UsersController < ApplicationController

  before_action :authenticate_user
  # Filters
  #skip_before_action :authenticate_admin_user!, only: :dashboard
  #before_action :checks_for_logged_in_user, only: :dashboard
  #before_action :set_resource, only: [:edit, :update, :deactivate, :activate]
  #before_action :set_current_user

  def index
    @q = User.ransack(params[:q])
    @users = @q.result.page(params[:page])
  end

  def new
    @user = User.new
  end

  def dashboard
  end

  def create
    @user = User.new(admin_user_params)
    if @user.save
      set_flash_notification :success, :create, entity: 'Admin'
      redirect_to admin_user_path
    else
      set_instant_flash_notification :danger, :default, {:message => @user.errors.messages[:base][0]}
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(admin_user_params)
      set_flash_notification :success, :update, entity: 'Admin'
      redirect_to admin_admin_users_path
    else
      set_instant_flash_notification :danger, :default, {:message => @user.errors.messages[:base][0]}
      render :edit
    end
  end

  private
  def admin_user_params
    params.require(:user).permit(:name, :password, :mobile_number, :email, :status, :user_type, role_ids: [])
  end

  def check_for_correct_permission
    return true if current_user.super_admin?

    if current_user.admin? && (@user.admin? || @user.super_admin?)
      set_flash_notification :danger, :unauthorized
      redirect_to admin_users_path
    end
  end

  def set_user_type
    if current_user.super_admin?
      @user.user_type = params[:admin_user][:user_type]
    end
  end

  def checks_for_assigned_roles
    @user.added_role_ids = (permitted_update_params[:role_ids] - @user.role_ids.collect(&:to_s)).reject(&:empty?)
  end


  def checks_for_logged_in_user
    unless admin_user_signed_in?
      protocol = Rails.application.routes.default_url_options[:protocol] || "http"
      redirect_to new_user_session_url(protocol: protocol)
    end
  end
end