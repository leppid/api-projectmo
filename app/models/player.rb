class Player < ApplicationRecord
  has_secure_password

  before_create :set_initial_data

  validates :login, presence: true

  private

  def set_initial_data
    self.location = ENV['PLAYER_INITIAL_LOCATION']
    self.position = ENV['PLAYER_INITIAL_POSITION']
  end
end
