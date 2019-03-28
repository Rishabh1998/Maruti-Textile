class Admin::DaanasController < ApiController
  before_action :authenticate_user

  def index
    @q = Daana.ransack(params[:q])
    @daanas = @q.result.paginate(page: params[:page], per_page: 10)
  end

  def new
    @daana = Daana.new
  end

  def create
    @daana = Daana.new(daana_params)
    if @daana.save
      set_flash_notification :success, :create, entity: 'Daana'
      redirect_to admin_daanas_path
    else
      set_instant_flash_notification :danger, :default, {:message => @daana.errors.messages[:base][0]}
      render :new
    end
  end

  def edit
    @daana = Daana.find(params[:id])
  end

  def update
    @daana = Daana.find(params[:id])
    if @daana.update(daana_params)
      set_flash_notification :success, :update, entity: 'Daana'
      redirect_to admin_daanas_path
    else
      set_instant_flash_notification :danger, :default, {:message => @daana.errors.messages[:base][0]}
      render :edit
    end
  end

  def destroy
    @bobin = Daana.find(params[:id])
    @bobin.delete
    redirect_to admin_daanas_path
  end

  def upload_daana_image
    UploadToS3Service.new(params[:document], params[:id], {extension: 'jpg', public_read: true, upload_folder: "daanas"}).update_file
    set_flash_notification :success, :update, entity: 'Daana'
    redirect_to admin_daanas_path
  end

  private

  def daana_params
    params.require(:daana).permit(:party_id, :type_id, :quantity, :rate)
  end
end