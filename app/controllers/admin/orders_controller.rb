class Admin::OrdersController < ApiController
  before_action :authenticate_user

  def index
    if @current_user.preference == 'grocery'
      @orders = Order.includes(:customer, :order_items).all
    else
      @orders = Order.includes(:customer, :order_items).all
    end
  end

  def show
    @order = Order.find(params[:id])
  end
end