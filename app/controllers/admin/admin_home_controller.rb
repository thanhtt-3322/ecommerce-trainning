class Admin::AdminHomeController < ApplicationController
  authorize_resource class: :admin_home

  def index
    @user_count = User.count
    @product_count = Product.count
    @orders_this_month = Order.this_month.count
  end
end
