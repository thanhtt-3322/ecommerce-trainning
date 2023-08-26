class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items, dependent: :destroy

  validates :name, presence: true, length: { maximum: Settings.product.validates.name.max }
  validates :price, presence: true, numericality: { greater_than: Settings.product.validates.price.min,
                                    less_than_or_equal_to: Settings.product.validates.price.max }
  validates :status, presence: true, inclusion: { in: %w(enabled disabled) }

  enum status: %i(enabled disabled)
  
  has_one_attached :image, dependent: :destroy
  has_rich_text :body
end
