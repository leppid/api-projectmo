class Player < ApplicationRecord
  has_secure_password

  has_and_belongs_to_many :armors, join_table: 'players_armors', association_foreign_key: :armor_id, class_name: 'Armor::Base', dependent: :destroy

  has_and_belongs_to_many :head_armors, join_table: :players_armors, association_foreign_key: :armor_id, class_name: 'Armor::Head'
  has_and_belongs_to_many :body_armors, join_table: :players_armors, association_foreign_key: :armor_id, class_name: 'Armor::Body'
  has_and_belongs_to_many :legs_armors, join_table: :players_armors, association_foreign_key: :armor_id, class_name: 'Armor::Legs'

  has_and_belongs_to_many :weapons, join_table: :players_weapons, association_foreign_key: :weapon_id, class_name: 'Weapon::Base', dependent: :destroy

  has_and_belongs_to_many :primary_weapons, join_table: :players_weapons, association_foreign_key: :weapon_id, class_name: 'Weapon::Primary'
  has_and_belongs_to_many :secondary_weapons, join_table: :players_weapons, association_foreign_key: :weapon_id, class_name: 'Weapon::Secondary'

  has_and_belongs_to_many :items, join_table: :players_items, association_foreign_key: :item_id, class_name: 'Item::Base', dependent: :destroy

  belongs_to :head, class_name: 'Armor::Head', optional: true
  belongs_to :body, class_name: 'Armor::Body', optional: true
  belongs_to :legs, class_name: 'Armor::Legs', optional: true

  belongs_to :primary, class_name: 'Weapon::Primary', optional: true
  belongs_to :secondary, class_name: 'Weapon::Secondary', optional: true

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
