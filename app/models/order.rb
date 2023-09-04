class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  validates :phone, :address, presence: true

  before_create :calculate_total_price

  enum status: %i(wait_confirm delivering completed canceled)

  default_scope { order(id: :desc) }

  private

  def calculate_total_price
    self.total_price = order_items.sum { |item| item.product.price * item.quantity }
  end
end
