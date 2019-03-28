class Admin::GittisController < ApiController
  before_action :authenticate_user

  def index
    @q = Gitti.ransack(params[:q])
    @gittis = @q.result.paginate(page: params[:page], per_page: 10)
  end

  def new
    @gitti = Gitti.new
  end

  def create
    @gitti = Gitti.new(gitti_params)
    if @gitti.save
      set_flash_notification :success, :create, entity: 'Gitti'
      redirect_to admin_gittis_path
    else
      set_instant_flash_notification :danger, :default, {:message => @gitti.errors.messages[:base][0]}
      render :new
    end
  end

  def edit
    @gitti = Gitti.find(params[:id])
  end

  def update
    @gitti = Gitti.find(params[:id])
    if @gitti.update(gitti_params)
      set_flash_notification :success, :update, entity: 'Gitti'
      redirect_to admin_gittis_path
    else
      set_instant_flash_notification :danger, :default, {:message => @gitti.errors.messages[:base][0]}
      render :edit
    end
  end

  def destroy
    @bobin = Gitti.find(params[:id])
    @bobin.delete
    redirect_to admin_gittis_path
  end

  def upload_gitti_image
    UploadToS3Service.new(params[:document], params[:id], {extension: 'jpg', public_read: true, upload_folder: "gittis"}).update_file
    set_flash_notification :success, :update, entity: 'Gitti'
    redirect_to admin_gittis_path
  end

  private

  def gitti_params
    params.require(:gitti).permit(:party_id, :quantity, :rate)
  end
end