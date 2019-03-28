class Admin::PlasticScrapsController < ApiController
  before_action :authenticate_user

  def index
    @q = PlasticScrap.ransack(params[:q])
    @plastic_scraps = @q.result.paginate(page: params[:page], per_page: 10)
  end

  def new
    @plastic_scrap = PlasticScrap.new
  end

  def create
    @plastic_scrap = PlasticScrap.new(plastic_scrap_params)
    if @plastic_scrap.save
      set_flash_notification :success, :create, entity: 'Plastic_scrap'
      redirect_to admin_plastic_scraps_path
    else
      set_instant_flash_notification :danger, :default, {:message => @plastic_scrap.errors.messages[:base][0]}
      render :new
    end
  end

  def edit
    @plastic_scrap = PlasticScrap.find(params[:id])
  end

  def update
    @plastic_scrap = PlasticScrap.find(params[:id])
    if @plastic_scrap.update(plastic_scrap_params)
      set_flash_notification :success, :update, entity: 'Plastic_scrap'
      redirect_to admin_plastic_scraps_path
    else
      set_instant_flash_notification :danger, :default, {:message => @plastic_scrap.errors.messages[:base][0]}
      render :edit
    end
  end

  def destroy
    @bobin = PlasticScrap.find(params[:id])
    @bobin.delete
    redirect_to admin_plastic_scraps_path
  end

  def upload_plastic_scrap_image
    UploadToS3Service.new(params[:document], params[:id], {extension: 'jpg', public_read: true, upload_folder: "plastic_scraps"}).update_file
    set_flash_notification :success, :update, entity: 'Plastic_scrap'
    redirect_to admin_plastic_scraps_path
  end

  private

  def plastic_scrap_params
    params.require(:plastic_scrap).permit(:party_id, :type_id, :rate, :weight, :delhi_weight, :bhiwani_weight, :bags_quantity, :bardana, :labour)
  end
end