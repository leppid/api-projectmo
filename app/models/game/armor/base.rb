class Game::Armor::Base < ApplicationRecord
  TYPES = ['Game::Armor::Base', 'Game::Armor::Head', 'Game::Armor::Body', 'Game::Armor::Legs']

  self.table_name = 'game_armors'

  has_many :player_armors, class_name: 'Player::Armor::Base', dependent: :destroy
end
