class Admin::BobinsController < ApiController
  before_action :authenticate_user

  def index
    @q = Bobin.ransack(params[:q])
    @bobins = @q.result.paginate(page: params[:page], per_page: 10)
  end

  def new
    @bobin = Bobin.new
  end

  def create
    @bobin = Bobin.new(bobin_params)
    if @bobin.save
      set_flash_notification :success, :create, entity: 'Bobin'
      redirect_to admin_bobins_path
    else
      set_instant_flash_notification :danger, :default, {:message => @bobin.errors.messages[:base][0]}
      render :new
    end
  end

  def edit
    @bobin = Bobin.find(params[:id])
  end

  def update
    @bobin = Bobin.find(params[:id])
    if @bobin.update(bobin_params)
      set_flash_notification :success, :update, entity: 'Bobin'
      redirect_to admin_bobins_path
    else
      set_instant_flash_notification :danger, :default, {:message => @bobin.errors.messages[:base][0]}
      render :edit
    end
  end

  def upload_bobin_image
    UploadToS3Service.new(params[:document], params[:id], {extension: 'jpg', public_read: true, upload_folder: "bobins"}).update_file
    set_flash_notification :success, :update, entity: 'Bobin'
    redirect_to admin_bobins_path
  end

  private

  def bobin_params
    params.require(:bobin).permit(:party_id, :quantity, :rate)
  end
end