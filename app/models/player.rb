class Player < ApplicationRecord
  has_secure_password

  has_one :head_slot, class_name: 'Slot::Head', dependent: :destroy
  has_one :body_slot, class_name: 'Slot::Body', dependent: :destroy
  has_one :legs_slot, class_name: 'Slot::Legs', dependent: :destroy

  has_one :primary_slot, class_name: 'Slot::Primary', dependent: :destroy
  has_one :secondary_slot, class_name: 'Slot::Secondary', dependent: :destroy

  has_many :bag_slots, class_name: 'Slot::Bag', dependent: :destroy

  has_one :head_armor, class_name: 'Game::Armor::Head', through: :head_slot, source: :head_armor, dependent: :destroy
  has_one :body_armor, class_name: 'Game::Armor::Body', through: :body_slot, source: :body_armor, dependent: :destroy
  has_one :legs_armor, class_name: 'Game::Armor::Legs', through: :legs_slot, source: :legs_armor, dependent: :destroy

  has_one :primary_weapon, class_name: 'Game::Weapon::Primary', through: :primary_slot, source: :primary_weapon, dependent: :destroy
  has_one :secondary_weapon, class_name: 'Game::Weapon::Secondary', through: :secondary_slot, source: :secondary_weapon, dependent: :destroy

  has_many :bag_armors, class_name: 'Game::Armor::Base', through: :bag_slots, source: :bagable, source_type: 'Game::Armor::Base', dependent: :destroy
  has_many :bag_weapons, class_name: 'Game::Weapon::Base', through: :bag_slots, source: :bagable, source_type: 'Game::Weapon::Base', dependent: :destroy
  has_many :bag_items, class_name: 'Game::Item::Base', through: :bag_slots, source: :bagable, source_type: 'Game::Item::Base', dependent: :destroy

  before_create :set_initial_data

  after_create :create_slots

  validates :login, presence: true, uniqueness: true

  def armors
    Game::Armor::Base.where(id: bag_armors.pluck(:id) + [head_armor&.id, body_armor&.id, legs_armor&.id])
  end

  def weapons
    Game::Weapon::Base.where(id: bag_weapons.pluck(:id) + [primary_weapon&.id, secondary_weapon&.id])
  end

  def items
    Game::Item::Base.where(id: bag_items.pluck(:id))
  end

  def self.cc
    find_by(login: 'playercc') || create(login: 'playercc', password: 'password')
  end

  def create_bag_page
    12.times do
      bag_slots.create
    end
  end

  def first_empty_bag_slot
    bag_slots.find_by(bagable_id: nil)
  end

  private

  def set_initial_data
    self.display_name = self.login
    self.login = self.login.downcase
    self.location = ENV['PLAYER_INITIAL_LOCATION']
    self.position = ENV['PLAYER_INITIAL_POSITION']
  end

  def create_slots
    create_head_slot
    create_body_slot
    create_legs_slot

    create_primary_slot
    create_secondary_slot

    create_bag_page
  end
end
