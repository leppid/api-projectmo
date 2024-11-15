class Weapon::Base < ApplicationRecord
  TYPES = ['Weapon::Base', 'Weapon::Primary', 'Weapon::Secondary']

  self.table_name = 'weapons'

  has_and_belongs_to_many :players, join_table: :players_weapons, foreign_key: :weapon_id, association_foreign_key: :player_id
end
