class Admin::TypesController < ApiController
  before_action :authenticate_user

  def index
    @q = Type.ransack(params[:q])
    @types = @q.result.paginate(page: params[:page], per_page: 10)
  end

  def new
    @type = Type.new
  end

  def create
    @type = Type.new(type_params)
    if @type.save
      set_flash_notification :success, :create, entity: 'Type'
      redirect_to admin_types_path
    else
      set_instant_flash_notification :danger, :default, {:message => @type.errors.messages[:base][0]}
      render :new
    end
  end

  def edit
    @type = Type.find(params[:id])
  end

  def update
    @type = Type.find(params[:id])
    if @type.update(type_params)
      set_flash_notification :success, :update, entity: 'Type'
      redirect_to admin_types_path
    else
      set_instant_flash_notification :danger, :default, {:message => @type.errors.messages[:base][0]}
      render :edit
    end
  end

  def upload_type_image
    UploadToS3Service.new(params[:document], params[:id], {extension: 'jpg', public_read: true, upload_folder: "types"}).update_file
    set_flash_notification :success, :update, entity: 'Type'
    redirect_to admin_types_path
  end

  private

  def type_params
    params.require(:type).permit(:name, :color_id, :description)
  end
end