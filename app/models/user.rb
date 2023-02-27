class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, length: { in: 2..50 }
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  has_many :trips
  has_many :reservations
end
