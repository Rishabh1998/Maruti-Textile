class Admin::ColorsController < ApiController
  before_action :authenticate_user

  def index
    @q = Color.ransack(params[:q])
    @colors = @q.result.paginate(page: params[:page], per_page: 10)
  end

  def new
    @color = Color.new
  end

  def create
    @color = Color.new(color_params)
    if @color.save
      set_flash_notification :success, :create, entity: 'Color'
      redirect_to admin_colors_path
    else
      set_instant_flash_notification :danger, :default, {:message => @color.errors.messages[:base][0]}
      render :new
    end
  end

  def edit
    @color = Color.find(params[:id])
  end

  def update
    @color = Color.find(params[:id])
    if @color.update(color_params)
      set_flash_notification :success, :update, entity: 'Color'
      redirect_to admin_colors_path
    else
      set_instant_flash_notification :danger, :default, {:message => @color.errors.messages[:base][0]}
      render :edit
    end
  end

  def upload_color_image
    UploadToS3Service.new(params[:document], params[:id], {extension: 'jpg', public_read: true, upload_folder: "colors"}).update_file
    set_flash_notification :success, :update, entity: 'Color'
    redirect_to admin_colors_path
  end

  private

  def color_params
    params.require(:color).permit(:name, :description)
  end
end