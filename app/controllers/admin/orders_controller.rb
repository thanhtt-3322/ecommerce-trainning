class Admin::OrdersController < ApplicationController
  def index
    @orders = Order.all
    @order_statuses = Order.statuses
  end
end
