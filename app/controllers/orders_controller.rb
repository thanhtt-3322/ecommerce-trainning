class OrdersController < ApplicationController
  before_action :load_categories, only: %i(index)
  def index
    return if current_user.nil?
    @orders = current_user.orders.order(created_at: :desc)
  end

  def create
    return if current_user.nil?

    @order = current_user.orders.build(order_params)
    cart_items = JSON.parse(cookies[:cart_items])
    @order.build_order_items_from_cart cart_items

    if @order.save
      cookies.delete(:cart_items)

      flash[:success] = "Order successfully placed!"
      redirect_to orders_path
    else
      flash[:error] = "Order failed!"
    end
  end

  def update
    order = Order.find(params[:id])
    binding.pry

    if order.wait_confirm?
      order.canceled!
      redirect_to orders_path, notice: "Order was successfully canceled."
    else
      redirect_to orders_path, alert: "Unable to cancel order."
    end
  end

  private

  def order_params
    params.require(:order).permit(:address, :phone, :reason_description, :status)
  end
end
