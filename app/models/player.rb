class Player < ApplicationRecord
  has_secure_password

  before_create :set_initial_data

  has_and_belongs_to_many :armors, join_table: 'players_armors', association_foreign_key: :armor_id, class_name: 'Armor::Base', dependent: :destroy

  has_and_belongs_to_many :helmets, join_table: :players_armors, association_foreign_key: :armor_id, class_name: 'Armor::Helmet'
  has_and_belongs_to_many :bips, join_table: :players_armors, association_foreign_key: :armor_id, class_name: 'Armor::Bip'
  has_and_belongs_to_many :pants, join_table: :players_armors, association_foreign_key: :armor_id, class_name: 'Armor::Pants'

  has_and_belongs_to_many :weapons, join_table: :players_weapons, association_foreign_key: :weapon_id, class_name: 'Weapon::Base', dependent: :destroy

  has_and_belongs_to_many :primary_weapons, join_table: :players_weapons, association_foreign_key: :weapon_id, class_name: 'Weapon::Primary'
  has_and_belongs_to_many :secondary_weapons, join_table: :players_weapons, association_foreign_key: :weapon_id, class_name: 'Weapon::Secondary'

  has_and_belongs_to_many :items, join_table: :players_items, association_foreign_key: :item_id, class_name: 'Item::Base', dependent: :destroy

  belongs_to :helmet, class_name: 'Armor::Helmet', optional: true
  belongs_to :bip, class_name: 'Armor::Bip', optional: true
  belongs_to :pants, class_name: 'Armor::Pants', optional: true
  belongs_to :primary, class_name: 'Weapon::Primary', optional: true
  belongs_to :secondary, class_name: 'Weapon::Secondary', optional: true

  validates :login, presence: true, uniqueness: true
  def self.ccreate
    create(login: 'vodenb', password: 'motherlode')
  end

  private

  def set_initial_data
    self.display_name = self.login
    self.login = self.login.downcase
    self.location = ENV['PLAYER_INITIAL_LOCATION']
    self.position = ENV['PLAYER_INITIAL_POSITION']
  end
end
