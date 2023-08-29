class HomeController < ApplicationController
  before_action :load_categories, only: %i(index)

  def index
    @recommended_products = Product.enabled.recommended
    @best_sellers = Product.enabled.best_sellers
    @new_arrival_products = Product.enabled.new_arrival
  end
end
