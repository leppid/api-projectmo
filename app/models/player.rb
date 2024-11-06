class Player < ApplicationRecord
  has_secure_password
  validates :login, presence: true
end
