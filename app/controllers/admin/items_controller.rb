class Admin::ItemsController < ApiController
  before_action :authenticate_user

  def index
    @q = Item.includes(:section, :division, :department).ransack(params[:q])
    @items = @q.result.paginate(page: params[:page], per_page: 10)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(cat_params)
    if @item.save
      set_flash_notification :success, :create, entity: ' Item'
      redirect_to admin_item_items_path
    else
      set_instant_flash_notification :danger, :default, {:message => @item.errors.messages[:base][0]}
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(cat_params)
      set_flash_notification :success, :update, entity: ' Item'
      redirect_to admin_item_items_path
    else
      set_instant_flash_notification :danger, :default, {:message => @item.errors.messages[:base][0]}
      render :edit
    end
  end

  def upload_item_image
    UploadToS3Service.new(params[:document], params[:barcode], {extension: 'jpg', public_read: true, upload_folder: "items"}).update_file
    set_flash_notification :success, :update, entity: ' Item'
    redirect_to admin_item_items_path
  end

  private

  def cat_params
    params.require(:item).permit(:division_id, :section_id, :department_id, :category, :company_name, :name, :mrp,
                                         :discount, :rsp, :standard_rate, :barcode, :item_hsn_description, :item_code, :item_hsn_code, :display, :status)
  end
end