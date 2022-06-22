class Product < ApplicationRecord

  has_one_attached :image
  belongs_to :genre

  validates :image, presence: true

end
