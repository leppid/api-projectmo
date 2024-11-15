class PlayersWeapons < ApplicationRecord
  self.table_name = 'players_weapons'

  belongs_to :player, class_name: 'Player', foreign_key: 'player_id'
  belongs_to :weapon, class_name: 'Weapon::Base', foreign_key: 'weapon_id'

  validates :player_id, :weapon_id, presence: true
end
