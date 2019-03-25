class Admin::TapesController < ApiController
  before_action :authenticate_user

  def index
    @q = Tape.ransack(params[:q])
    @tapes = @q.result.paginate(page: params[:page], per_page: 10)
  end

  def new
    @tape = Tape.new
  end

  def create
    @tape = Tape.new(tape_params)
    if @tape.save
      set_flash_notification :success, :create, entity: 'Tape'
      redirect_to admin_tapes_path
    else
      set_instant_flash_notification :danger, :default, {:message => @tape.errors.messages[:base][0]}
      render :new
    end
  end

  def edit
    @tape = Tape.find(params[:id])
  end

  def update
    @tape = Tape.find(params[:id])
    if @tape.update(tape_params)
      set_flash_notification :success, :update, entity: 'Tape'
      redirect_to admin_tapes_path
    else
      set_instant_flash_notification :danger, :default, {:message => @tape.errors.messages[:base][0]}
      render :edit
    end
  end

  def upload_tape_image
    UploadToS3Service.new(params[:document], params[:id], {extension: 'jpg', public_read: true, upload_folder: "tapes"}).update_file
    set_flash_notification :success, :update, entity: 'Tape'
    redirect_to admin_tapes_path
  end

  private

  def tape_params
    params.require(:tape).permit(:party_id, :type_name, :rate, :quantity)
  end
end