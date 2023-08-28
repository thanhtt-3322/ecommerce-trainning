class Admin::ProductsController < ApplicationController
  before_action :load_product, only: %i(edit update)
  before_action :load_categories, only: %i(new edit)
  
  def index
    @pagy, @products = pagy(Product.all, items: Settings.product.paginates)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save 
      flash[:success] = t("admin.crud.product.success_message")
      redirect_to action: :index
    else
      load_categories
      render :new
    end
  end

  def edit; end
  
  def update
    if @product.update(product_params)
      flash[:success] = t("admin.crud.product.success_message")
      redirect_to admin_products_path
    else
      load_categories
      render :edit
    end
  end

  private

  def load_product
    return if @product = Product.find_by(id: params[:id])
    
    flash[:error] = "Product isn't exist!"
    redirect_to action: :index
  end

  def product_params
    params.require(:product).permit(:name, :price, :description, :status, :category_id, :image, :body)
  end
end
