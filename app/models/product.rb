class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items, dependent: :destroy

  enum status: %i(enabled disabled)
end
