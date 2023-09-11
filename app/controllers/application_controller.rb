class ApplicationController < ActionController::Base
  include Pagy::Backend

  helper_method :current_user, :load_categories

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  private

  def reload_cart
    cookies[:cart_items] = @cart_items.to_json
  end

  def cart_items
    cart_items_string = cookies[:cart_items]
    @cart_items = cart_items_string.present? ? JSON.parse(cart_items_string) : {}

    @cart_items.reject! do |product_id, quantity|
      Product.enabled.find_by(id: product_id).blank?
    end
  end

  def load_categories
    @categories = Category.all
  end

  def load_product
    return if @product = Product.find_by(id: params[:id])

    flash[:error] = "Product isn't exist!"
    redirect_to action: :index
  end

  def current_user
    @current_user ||= session[:remember_token] && User.find_by_remember_token(session[:remember_token])
  end

  def redirect_back_or(default)
    redirect_to session[:return_to] || default
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath
  end
end
