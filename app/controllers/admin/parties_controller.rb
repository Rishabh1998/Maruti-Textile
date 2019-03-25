class Admin::PartiesController < ApiController
  before_action :authenticate_user

  def index
    @q = Party.ransack(params[:q])
    @parties = @q.result.paginate(page: params[:page], per_page: 10)
  end

  def new
    @party = Party.new
  end

  def create
    @party = Party.new(party_params)
    if @party.save
      set_flash_notification :success, :create, entity: 'Party'
      redirect_to admin_parties_path
    else
      set_instant_flash_notification :danger, :default, {:message => @party.errors.messages[:base][0]}
      render :new
    end
  end

  def edit
    @party = Party.find(params[:id])
  end

  def update
    @party = Party.find(params[:id])
    if @party.update(party_params)
      set_flash_notification :success, :update, entity: 'Party'
      redirect_to admin_parties_path
    else
      set_instant_flash_notification :danger, :default, {:message => @party.errors.messages[:base][0]}
      render :edit
    end
  end

  def upload_party_image
    UploadToS3Service.new(params[:document], params[:id], {extension: 'jpg', public_read: true, upload_folder: "parties"}).update_file
    set_flash_notification :success, :update, entity: 'Party'
    redirect_to admin_parties_path
  end

  private

  def party_params
    params.require(:party).permit(:name, :address, :mobile_number, :gstin, :rate, :weight)
  end
end