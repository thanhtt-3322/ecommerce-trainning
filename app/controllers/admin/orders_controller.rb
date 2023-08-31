class Admin::OrdersController < ApplicationController
  authorize_resource
  
  before_action :load_order, only: %i(edit update)

  def index
    @pagy, @orders = pagy(load_orders, items: Settings.order.admin.paginates)
  end

  def edit; end

  def update
    if @order.update(order_params)
      flash[:success] = "Order status updated successfully!"
      redirect_to admin_orders_path

      send_mail_confirm if @order.delivering?
      send_reject_order if @order.canceled?
      update_sold_product if @order.completed?
    else
      flash.now[:error] = "Failed to update order status!"
      render :edit
    end
  end

  private

  def update_sold_product
    @order.order_items.each do |order_iem|
      sold = order_iem.product.sold.to_i
      order_iem.product.update(sold: sold + order_iem.quantity)
    end
  end

  def send_reject_order
    OrderMailer.with(order: @order).reject_order.deliver_later
  end

  def send_mail_confirm
    OrderMailer.with(order: @order).confirm_order.deliver_later
  end

  def load_order
    return if @order = Order.find_by(id: params[:id])

    flash[:error] = "Order isn't exist!"
    redirect_to action: :index
  end

  def load_orders
    return Order.where(status: params[:status]) if params[:status].present?

    Order.all
  end

  def order_params
    params.require(:order).permit(:status, :reason_description)
  end
end
