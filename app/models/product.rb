class Product < ApplicationRecord

  has_one_attached :image
  belongs_to :genre
  has_many :cart_products
  has_many :order_products

  validates :image, presence: true
  validates :name, presence: true
  validates :introduction, presence: true
  validates :price, presence: true
  validates :is_actice, presence: true


  def with_tax_price
    (price*1.1).floor.to_s(:delimited, delimiter: ',')
  end

end
