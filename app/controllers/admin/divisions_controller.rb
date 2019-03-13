class Admin::DivisionsController < ApiController
  before_action :authenticate_user

  def index
    @q = Division.ransack(params[:q])
    @divisions = @q.result.paginate(page: params[:page], per_page: 10)
  end

  def new
    @division = Division.new
  end

  def create
    @division = Division.new(div_params)
    if @division.save
      set_flash_notification :success, :create, entity: 'Division'
      redirect_to admin_divisions_path
    else
      set_instant_flash_notification :danger, :default, {:message => @division.errors.messages[:base][0]}
      render :new
    end
  end

  def edit
    @division = Division.find(params[:id])
  end

  def update
    @division = Division.find(params[:id])
    if @division.update(div_params)
      set_flash_notification :success, :update, entity: 'Division'
      redirect_to admin_divisions_path
    else
      set_instant_flash_notification :danger, :default, {:message => @division.errors.messages[:base][0]}
      render :edit
    end
  end

  def upload_division_image
    UploadToS3Service.new(params[:document], params[:id], {extension: 'jpg', public_read: true, upload_folder: "divisions"}).update_file
    set_flash_notification :success, :update, entity: 'Division'
    redirect_to admin_divisions_path
  end

  private

  def div_params
    params.require(:division).permit(:name,:status)
  end
end