class Admin::HomeController < Admin::ApplicationController
  def index
    @url = rails_blob_url(Product.first.image)
    @user_count = User.count
    @product_count = Product.count
    @orders_this_month = Order.this_month.count
  end
end
