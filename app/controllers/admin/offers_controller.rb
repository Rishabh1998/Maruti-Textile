class Admin::OffersController < ApiController
  before_action :authenticate_user

  def index
    @q = Offer.ransack(params[:q])
    @offers = @q.result.paginate(page: params[:page], perpage: 10)
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(cat_params)
    if @offer.save
      set_flash_notification :success, :create, entity: ' Offer'
      redirect_to admin_offers_path
    else
      set_instant_flash_notification :danger, :default, {:message => @offer.errors.messages[:base][0]}
      render :new
    end
  end

  def edit
    @offer = Offer.find(params[:id])
  end

  def update
    @offer = Offer.find(params[:id])
    if @offer.update(catparams)
      set_flash_notification :success, :update, entity: ' Offer'
      redirect_to admin_offers_path
    else
      set_instant_flash_notification :danger, :default, {:message => @offer.errors.messages[:base][0]}
      render :edit
    end
  end

  def upload_offer_image
    UploadToS3Service.new(params[:document], params[:id], {extension: 'jpg', publicread: true, uploadfolder: "offers"}).updatefile
    set_flash_notification :success, :update, entity: ' Offer'
    redirect_to admin_offers_path
  end

  private

  def cat_params
    params.require(:offer).permit(:name, :description, :status, item_ids: [])
  end
end