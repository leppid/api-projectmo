class PlayersArmors < ApplicationRecord
  self.table_name = 'players_armors'

  belongs_to :player, class_name: 'Player', foreign_key: 'player_id'
  belongs_to :armor, class_name: 'Armor::Base', foreign_key: 'armor_id'

  validates :player_id, :armor_id, presence: true
end
