class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, length: { in: 2..50 }

  has_many :trips
  has_many :reservations
end
