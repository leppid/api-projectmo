class PlayersItems < ApplicationRecord
  self.table_name = 'players_items'

  belongs_to :player, class_name: 'Player', foreign_key: 'player_id'
  belongs_to :item, class_name: 'Item::Base', foreign_key: 'item_id'

  validates :player_id, :item_id, presence: true
end
