class Admin::OrdersController < ApplicationController
  before_action :load_order, only: %i(edit update)

  def index
    @pagy, @orders = pagy(load_orders, items: Settings.order.paginates)
  end

  def edit; end

  def update
    if @order.update(order_params)
      flash[:success] = "Order status updated successfully!"
      redirect_to admin_orders_path
    else
      flash.now[:error] = "Failed to update order status!"
      render :edit
    end
  end

  private

  def load_order
    return if @order = Order.find_by(id: params[:id])
    
    flash[:error] = "Order isn't exist!"
    redirect_to action: :index
  end

  def load_orders
    return Order.where(status: params[:status]) if params[:status]

    Order.all
  end

  def order_params
    params.require(:order).permit(:status)
  end
end
