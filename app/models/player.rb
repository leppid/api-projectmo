class Player < ApplicationRecord
  has_secure_password

  has_one :head_slot, class_name: 'Game::Armor::Head', foreign_key: :head_slot_id
  has_one :body_slot, class_name: 'Game::Armor::Body', foreign_key: :body_slot_id
  has_one :legs_slot, class_name: 'Game::Armor::Legs', foreign_key: :legs_slot_id

  has_one :primary_slot, class_name: 'Game::Weapon::Primary', foreign_key: :primary_slot_id
  has_one :secondary_slot, class_name: 'Game::Weapon::Secondary', foreign_key: :secondary_slot_id

  has_many :armors, class_name: 'Game::Armor::Base', dependent: :destroy

  has_many :head_armors, class_name: 'Game::Armor::Head', through: :armors
  has_many :body_armors, class_name: 'Game::Armor::Body', through: :armors
  has_many :legs_armors, class_name: 'Game::Armor::Legs', through: :armors

  has_many :weapons, class_name: 'Game::Weapon::Base', dependent: :destroy

  has_many :primary_weapons, class_name: 'Game::Weapon::Primary', through: :weapons
  has_many :secondary_weapons, class_name: 'Game::Weapon::Secondary', through: :weapons

  has_many :items, class_name: 'Game::Item::Base', dependent: :destroy

  before_create :set_initial_data

  validates :login, presence: true, uniqueness: true

  def self.cc
    find_by(login: 'playercc') || create(login: 'playercc', password: 'password')
  end

  private

  def set_initial_data
    self.display_name = self.login
    self.login = self.login.downcase
    self.location = ENV['PLAYER_INITIAL_LOCATION']
    self.position = ENV['PLAYER_INITIAL_POSITION']
  end
end
