class Admin::UsersController < ApiController
  before_action :authenticate_user
  # Filters
  #skip_before_action :authenticate_user!, only: :dashboard
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
    @user = User.new(user_params)
    if @user.save
      set_flash_notification :success, :create, entity: 'Admin'
      redirect_to users_path
    else
      set_instant_flash_notification :danger, :default, {:message => @user.errors.messages[:base][0]}
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def edit_profile
    @user = current_user
  end

  def update_profile
    @user = current_user

    if @user.update(permitted_update_profile_params)
      redirect_to edit_profile_users_path
    else
      set_instant_flash_notification :danger, :default
      render :edit_profile
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      set_flash_notification :success, :update, entity: ''
      redirect_to users_path
    else
      set_instant_flash_notification :danger, :default, {:message => @user.errors.messages[:base][0]}
      render :edit
    end
  end

  def deactivate
    @user.deactivate
    set_flash_notification :notice, :update, entity: 'User'
    redirect_to users_path
  end

  def activate
    @user.activate
    set_flash_notification :notice, :update, entity: 'User'
    redirect_to users_path
  end

  private
  def user_params
    params.require(:admin_user).permit(:name, :password, :mobile_number, :email, :status, :user_type, role_ids: [])
  end

  def permitted_update_profile_params
    params.require(:user).permit(:first_name, :last_name, :nickname, :mobile_number)
  end

  def check_for_correct_permission
    return true if current_user.super_?

    if current_user.admin? && (@user.admin? || @user.super_admin?)
      set_flash_notification :danger, :unauthorized
      redirect_to users_path
    end
  end

  def set_user_type
    if current_user.super_?
      @user.user_type = params[:user][:user_type]
    end
  end

  def checks_for_assigned_roles
    @user.added_role_ids = (permitted_update_params[:role_ids] - @user.role_ids.collect(&:to_s)).reject(&:empty?)
  end

  def set_product_ids
    @user.product_ids = (params[:product_ids] || []).map(&:to_i)
  end


  def checks_for_logged_in_user
    unless user_signed_in?
      protocol = Rails.application.routes.default_url_options[:protocol] || "http"
      redirect_to new_user_session_url(protocol: protocol)
    end
  end
end

