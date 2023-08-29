class ProductsController < ApplicationController
  before_action :load_product, only: %i(show)
  before_action :load_categories, only: %i(index show)

  def index
    @pagy, @products = pagy(load_products, items: Settings.product.paginates)
  end

  def show; end

  private

  def load_products
    return Product.all unless params[:category_id]

    load_category
    @category.products
  end

  def load_category
    return if @category = Category.find_by(id: params[:category_id])

    flash[:error] = "This category doesn't exist!"
    redirect_to root_path
  end
end
