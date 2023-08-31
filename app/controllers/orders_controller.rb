class OrdersController < ApplicationController
  before_action :load_categories, only: :index
  before_action :authenticate_user
  before_action :cart_items, only: :create

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
      redirect_back(fallback_location: cart_path)
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = "Order failed! Please check your information for the order"
      redirect_back(fallback_location: cart_path)
    end
  end

  def update
    @order = Order.find_by(id: params[:id])
    redirect_to orders_path, notice: "Order was successfully canceled!" if cancel_order
  end

  private

  def send_mail_place_order
    OrderMailer.with(order: @order).place_order.deliver_later
  end

  def cancel_order
    return cancel_order_action if @order&.wait_confirm?

    flash[:error] = "Unable to cancel order"
    redirect_to orders_path and return
  end

  def cancel_order_action
    @order.update(reason_description: order_params[:reason_description])
    @order.canceled!
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
