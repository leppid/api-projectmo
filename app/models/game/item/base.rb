class Game::Item::Base < ApplicationRecord
  TYPES = ['Game::Item::Base']

  self.table_name = 'game_items'

  has_many :player_items, class_name: 'Player::Item::Base', dependent: :destroy
end
