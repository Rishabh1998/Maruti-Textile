class Admin::DepartmentsController < ApiController
  before_action :authenticate_user

  def index
    @q = Department.ransack(params[:q])
    @departments = @q.result.paginate(page: params[:page], per_page: 10)
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(cat_params)
    if @department.save
      set_flash_notification :success, :create, entity: 'Department'
      redirect_to admin_departments_path
    else
      set_instant_flash_notification :danger, :default, {:message => @department.errors.messages[:base][0]}
      render :new
    end
  end

  def edit
    @department = Department.find(params[:id])
  end

  def update
    @department = Department.find(params[:id])
    if @department.update(cat_params)
      set_flash_notification :success, :update, entity: 'Department'
      redirect_to admin_departments_path
    else
      set_instant_flash_notification :danger, :default, {:message => @department.errors.messages[:base][0]}
      render :edit
    end
  end

  def upload_department_image
    UploadToS3Service.new(params[:document], params[:id], {extension: 'jpg', public_read: true, upload_folder: "departments"}).update_file
    set_flash_notification :success, :update, entity: 'Department'
    redirect_to admin_departments_path
  end

  private

  def cat_params
    params.require(:department).permit(:name,:status)
  end
end