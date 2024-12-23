class Player < ApplicationRecord
  has_secure_password

  belongs_to :head_armor, class_name: 'Game::Armor::Head', optional: true, dependent: :destroy
  belongs_to :body_armor, class_name: 'Game::Armor::Body', optional: true, dependent: :destroy
  belongs_to :legs_armor, class_name: 'Game::Armor::Legs', optional: true, dependent: :destroy

  belongs_to :primary_weapon, class_name: 'Game::Weapon::Primary', optional: true, dependent: :destroy
  belongs_to :secondary_weapon, class_name: 'Game::Weapon::Secondary', optional: true, dependent: :destroy

  has_one :inventory_grid, class_name: 'Inventory::Grid', dependent: :destroy

  has_many :armors, class_name: 'Game::Armor::Base', dependent: :destroy

  has_many :head_armors, class_name: 'Game::Armor::Head', through: :armors
  has_many :body_armors, class_name: 'Game::Armor::Body', through: :armors
  has_many :legs_armors, class_name: 'Game::Armor::Legs', through: :armors

  has_many :weapons, class_name: 'Game::Weapon::Base', dependent: :destroy

  has_many :primary_weapons, class_name: 'Game::Weapon::Primary', through: :weapons
  has_many :secondary_weapons, class_name: 'Game::Weapon::Secondary', through: :weapons

  has_many :items, class_name: 'Game::Item::Base', dependent: :destroy

  validates :login, presence: true, uniqueness: true

  before_create :set_initial_data

  after_create :create_inventory_grid

  def self.cc
    find_by(login: 'playercc') || create(login: 'playercc', password: 'password')
  end

  def first_empty_slot
    inventory_grid.first_empty_slot
  end

  private

  def set_initial_data
    self.display_name = self.login
    self.login = self.login.downcase
    self.location = ENV['PLAYER_INITIAL_LOCATION']
    self.position = ENV['PLAYER_INITIAL_POSITION']
  end
end
