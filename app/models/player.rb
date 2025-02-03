class Player < ApplicationRecord
  has_secure_password

  has_one :head_slot, class_name: 'Slot::Head'
  has_one :body_slot, class_name: 'Slot::Body'
  has_one :legs_slot, class_name: 'Slot::Legs'
  has_one :primary_slot, class_name: 'Slot::Primary'
  has_one :secondary_slot, class_name: 'Slot::Secondary'

  delegate :head_armor, to: :head_slot, allow_nil: true
  delegate :body_armor, to: :body_slot, allow_nil: true
  delegate :legs_armor, to: :legs_slot, allow_nil: true
  delegate :primary_weapon, to: :primary_slot, allow_nil: true
  delegate :secondary_weapon, to: :secondary_slot, allow_nil: true

  has_many :bag_slots, class_name: 'Slot::Bag', dependent: :destroy
  has_many :slots, class_name: 'Slot::Base', dependent: :destroy
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

  after_create :create_equip_slots, :create_bag_slots, :create_bag_page

  def stuff
    armors + weapons + items
  end

  def empty_bag_slot
    bag_slots.order(:index).find(&:empty?)
  end

  def create_bag_page
    create_bag_slots
    update_column(:bag_pages, bag_pages + 1)
  end

  def remove_bag_page
    return if bag_pages < 2

    remove_bag_slots
    update_column(:bag_pages, bag_pages - 1)
  end

  def self.cc
    find_by(login: 'playercc') || create(login: 'playercc', password: 'password')
  end

  def create_equip_slots
    create_head_slot
    create_body_slot
    create_legs_slot
    create_primary_slot
    create_secondary_slot
  end

  private

  def set_initial_data
    self.display_name = self.login
    self.login = self.login.downcase
    self.location = ENV['MO_INITIAL_LOCATION']
    self.position = ENV['MO_INITIAL_POSITION']
  end

  def create_bag_slots
    12.times do
      bag_slots.create
    end
  end

  def remove_bag_slots
    12.times do
      bag_slots.order(:index).last.destroy
    end
  end
end
