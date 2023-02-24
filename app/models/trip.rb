class Trip < ApplicationRecord
  validates :price, presence: true, numericality: { only_float: true, greater_than_or_equal_to: 0 }
  validates :rating, presence: true
  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :rating, numericality: { less_than_or_equal_to: 5 }
  validates :destination_city, presence: true, length: { in: 2..75 }
  validates :description, presence: true, length: { in: 2..300 }
  # add image here to storage

  belongs_to :user
  has_many :reservations
end
