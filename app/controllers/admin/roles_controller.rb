class Admin::RolesController < ApiController
  # # Filters
  before_action :authenticate_user
  before_action :only_allow_super_admin
  before_action :set_resource, only: [ :update, :edit]

  def index
    @roles = Role.all.paginate(page: params[:page])
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(permitted_params)

    if @role.save
      set_flash_notification :success, :create, entity: 'Role'
      redirect_to admin_roles_path
    else
      set_instant_flash_notification :danger, :default
      render :new
    end
  end

  def edit
  end

  def update
    if @role.update(permitted_params)
      set_flash_notification :success, :update, entity: 'Role'
      redirect_to admin_roles_path
    else
      set_instant_flash_notification :danger, :default
      render :edit
    end
  end

  private
    def permitted_params
      params.require(:role).permit(:name, :description, :active, :admin_only, permission_ids: [])
    end
end

