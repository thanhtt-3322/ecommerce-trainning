class ProductsController < ApplicationController
  before_action :load_product, only: %i(show)
  before_action :load_categories, only: %i(index show search)

  def index
    @pagy, @products = pagy(list_product, items: Settings.product.paginates)
  end

  def show; end

  private

  def load_category
    return if @category = Category.find_by(id: params[:category_id])

    flash[:error] = "This category doesn't exist!"
    redirect_to root_path
  end

  def list_product
    return Product.enabled.search(params[:search_term]) if params[:search_term]
    return Product.enabled.where(category_id: params[:category_id]) if params[:category_id]
    Product.all 
  end
end
