class Trip < ApplicationRecord
  include Rails.application.routes.url_helpers
  validates :price, presence: true, numericality: { only_float: true, greater_than_or_equal_to: 0 }
  validates :rating, presence: true
  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :rating, numericality: { less_than_or_equal_to: 5 }
  validates :destination_city, presence: true, length: { in: 2..75 }
  validates :description, presence: true, length: { in: 2..300 }
  validates :image, presence: true, content_type: ['image/png', 'image/jpg', 'image/jpeg'],
                    size: { less_than: 5.megabytes }

  has_one_attached :image

  belongs_to :user
  has_many :reservations

  def image_url
    url_for(image)
  end
end
