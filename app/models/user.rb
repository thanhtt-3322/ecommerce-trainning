class User < ApplicationRecord  
  has_secure_password

  has_many :orders, dependent: :destroy
  has_many :order_items, through: :orders

  validates :name, presence: true, length: { maximum: Settings.user.validates.name.max }
  validates :email, presence: true, format: { with: Settings.regex.email }
  validates :password, presence: true, length: { minimum: Settings.user.validates.password.min }, on: :create
  validates :password_confirmation, presence: true, on: :create

  enum role: %i(user admin)
  enum status: %i(enabled disabled)
end
