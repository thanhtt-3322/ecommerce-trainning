class OrdersController < ApplicationController
  authorize_resource

  before_action :load_categories, only: :index
  before_action :cart_items, only: :create
  before_action :load_order, only: :update

  def index
    @pagy, @orders = pagy(load_orders, items: Settings.order.paginates)
  end

  def create
    @order = current_user.orders.build(order_params)
    begin
      build_order_items_from_cart
      ActiveRecord::Base.transaction do
        @order.save!
        cookies.delete(:cart_items)
        flash[:success] = "Order successfully placed! Please check your email to track the notification"
        redirect_to orders_path
  
        send_mail_place_order
      end
    rescue ActiveRecord::RecordNotFound => e
      reload_cart
      flash[:error] = "Product not found."
      redirect_to cart_path
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = "Order failed! Please fill out your address and phone"
      redirect_to cart_path
    end
  end

  def update
    return redirect_to orders_path, flash: { error: "Unable to cancel order when status isn't 'Wait for confirmation'" } unless @order.wait_confirm?

    @order.update(reason_description: order_params[:reason_description], status: "canceled")
    flash[:success] = "Order was successfully canceled!"
    redirect_to orders_path
  end

  private

  def load_order
    return if @order = Order.find_by(id: params[:id])

    flash[:error] = "Order not found"
    redirect_to action: :index
  end

  def send_mail_place_order
    OrderMailer.with(order: @order).place_order.deliver_now
  end

  def build_order_items_from_cart
    @cart_items.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      if product.nil?
        @cart_items.delete(product_id)        
        raise ActiveRecord::RecordNotFound, "Product not found"
      end
  
      @order.order_items.build(product: product, quantity: quantity, price: product.price)
    end
  end

  def load_orders
    return current_user.orders unless params[:status]

   current_user.orders.where(status: params[:status])
  end

  def order_params
    params.require(:order).permit(:address, :phone, :reason_description, :status)
  end
end
