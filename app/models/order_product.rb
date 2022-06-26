class OrderProduct < ApplicationRecord
  belongs_to :order, dependent: :destroy

end
