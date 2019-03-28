class Admin::ThelliesController < ApiController
  before_action :authenticate_user

  def index
    @q = Thelly.ransack(params[:q])
    @thellies = @q.result.paginate(page: params[:page], per_page: 10)
  end

  def new
    @thelly = Thelly.new
  end

  def create
    @thelly = Thelly.new(thelly_params)
    if @thelly.save
      set_flash_notification :success, :create, entity: 'Thelly'
      redirect_to admin_thellies_path
    else
      set_instant_flash_notification :danger, :default, {:message => @thelly.errors.messages[:base][0]}
      render :new
    end
  end

  def edit
    @thelly = Thelly.find(params[:id])
  end

  def update
    @thelly = Thelly.find(params[:id])
    if @thelly.update(thelly_params)
      set_flash_notification :success, :update, entity: 'Thelly'
      redirect_to admin_thellies_path
    else
      set_instant_flash_notification :danger, :default, {:message => @thelly.errors.messages[:base][0]}
      render :edit
    end
  end

  def destroy
    @bobin = Thelly.find(params[:id])
    @bobin.delete
    redirect_to admin_thellies_path
  end

  def upload_thelly_image
    UploadToS3Service.new(params[:document], params[:id], {extension: 'jpg', public_read: true, upload_folder: "thellies"}).update_file
    set_flash_notification :success, :update, entity: 'Thelly'
    redirect_to admin_thellies_path
  end

  private

  def thelly_params
    params.require(:thelly).permit(:party_id, :weight, :rate, :quantity)
  end
end