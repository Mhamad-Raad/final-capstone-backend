class Reservation < ApplicationRecord
  validates :date, presence: true
  validates :time, presence: true
  validates :departure_city, presence: true, length: { in: 2..75 }

end
