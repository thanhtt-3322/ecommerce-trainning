class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  before_save :calculate_total_price

  enum status: %i(wait_confirm delivering completed canceled)

  default_scope { order(created_at: :desc) }

  def build_order_items_from_cart(cart_items)
    cart_items.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      order_items.build(product: product, quantity: quantity, price: product.price)
    end
  end

  private 

  def calculate_total_price
    self.total_price = order_items.sum { |item| item.product.price * item.quantity }
  end
end
