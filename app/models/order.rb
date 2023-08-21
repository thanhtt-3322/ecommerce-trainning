class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  enum status: %i(wait_confirm delivering completed canceled)
end
