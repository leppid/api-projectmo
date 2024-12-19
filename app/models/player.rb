class Player < ApplicationRecord
  has_secure_password

  has_many :armors, class_name: 'Player::Armor::Base', dependent: :destroy

  has_many :head_armors, class_name: 'Player::Armor::Head'
  has_many :body_armors, class_name: 'Player::Armor::Body'
  has_many :legs_armors, class_name: 'Player::Armor::Legs'

  has_many :weapons, class_name: 'Player::Weapon::Base', dependent: :destroy

  has_many :primary_weapons, class_name: 'Player::Weapon::Primary'
  has_many :secondary_weapons, class_name: 'Player::Weapon::Secondary'

  has_many :items, class_name: 'Player::Item::Base', dependent: :destroy

  belongs_to :head_armor, class_name: 'Player::Armor::Head', optional: true
  belongs_to :body_armor, class_name: 'Player::Armor::Body', optional: true
  belongs_to :legs_armor, class_name: 'Player::Armor::Legs', optional: true

  belongs_to :primary_weapon, class_name: 'Player::Weapon::Primary', optional: true
  belongs_to :secondary_weapon, class_name: 'Player::Weapon::Secondary', optional: true

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
