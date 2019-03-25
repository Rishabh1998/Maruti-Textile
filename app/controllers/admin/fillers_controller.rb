class Admin::FillersController < ApiController
  before_action :authenticate_user

  def index
    @q = Filler.ransack(params[:q])
    @fillers = @q.result.paginate(page: params[:page], per_page: 10)
  end

  def new
    @filler = Filler.new
  end

  def create
    @filler = Filler.new(filler_params)
    if @filler.save
      set_flash_notification :success, :create, entity: 'Filler'
      redirect_to admin_fillers_path
    else
      set_instant_flash_notification :danger, :default, {:message => @filler.errors.messages[:base][0]}
      render :new
    end
  end

  def edit
    @filler = Filler.find(params[:id])
  end

  def update
    @filler = Filler.find(params[:id])
    if @filler.update(filler_params)
      set_flash_notification :success, :update, entity: 'Filler'
      redirect_to admin_fillers_path
    else
      set_instant_flash_notification :danger, :default, {:message => @filler.errors.messages[:base][0]}
      render :edit
    end
  end

  def upload_filler_image
    UploadToS3Service.new(params[:document], params[:id], {extension: 'jpg', public_read: true, upload_folder: "fillers"}).update_file
    set_flash_notification :success, :update, entity: 'Filler'
    redirect_to admin_fillers_path
  end

  private

  def filler_params
    params.require(:filler).permit(:party_id, :color_id, :quantity, :rate)
  end
end