class OrdersController < ApplicationController
  before_action :load_categories, only: %i(index)

  def index
    return redirect_to root_path if current_user.nil?
    
    @pagy, @orders = pagy(load_orders, items: Settings.order.paginates)
  end

  def create
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
    redirect_to orders_path, notice: "Order was successfully canceled!" if cancel_order Order.find_by(params[:id])
  end

  private

  def cancel_order(order)
    return order.canceled! if order.wait_confirm?

    flash[:error] = "Unable to cancel order"
    redirect_to orders_path
  end

  def load_orders
    return current_user.orders.where(status: params[:status]) if params[:status]

    current_user.orders
  end

  def order_params
    params.require(:order).permit(:address, :phone, :reason_description, :status)
  end
end
