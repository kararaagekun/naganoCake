class Product < ApplicationRecord

  has_one_attached :image
  belongs_to :genre

  validates :image, presence: true
  validates :name, presence: true
  validates :introduction, presence: true
  validates :price, presence: true
  validates :is_actice, presence: true

end
