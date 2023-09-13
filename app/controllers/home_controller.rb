class HomeController < ApplicationController
  def index
    @recommended_products = Product.enabled.recommended
    @best_sellers = Product.enabled.best_sellers
    @new_arrival_products = Product.enabled.new_arrival
  end

  def hello
    HelloJob.perform_at(10.seconds.from_now)
  end
end
