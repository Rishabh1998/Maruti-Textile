class Admin::SectionsController < ApiController
  before_action :authenticate_user

  def index
    @q = Section.ransack(params[:q])
    @sections = @q.result.paginate(page: params[:page], per_page: 10)
  end

  def new
    @section = Section.new
  end

  def create
    @section = Section.new(cat_params)
    if @section.save
      set_flash_notification :success, :create, entity: ' Section'
      redirect_to admin_sections_path
    else
      set_instant_flash_notification :danger, :default, {:message => @section.errors.messages[:base][0]}
      render :new
    end
  end

  def edit
    @section = Section.find(params[:id])
  end

  def update
    @section = Section.find(params[:id])
    if @section.update(cat_params)
      set_flash_notification :success, :update, entity: ' Section'
      redirect_to admin_sections_path
    else
      set_instant_flash_notification :danger, :default, {:message => @section.errors.messages[:base][0]}
      render :edit
    end
  end

  def upload_section_image
    UploadToS3Service.new(params[:document], params[:id], {extension: 'jpg', public_read: true, upload_folder: "sections"}).update_file
    set_flash_notification :success, :update, entity: ' Section'
    redirect_to admin_sections_path
  end

  private

  def cat_params
    params.require(:section).permit(:name,:status)
  end
end