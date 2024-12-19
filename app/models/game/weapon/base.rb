class Game::Weapon::Base < ApplicationRecord
  TYPES = ['Game::Weapon::Base', 'Game::Weapon::Primary', 'Game::Weapon::Secondary']

  self.table_name = 'game_weapons'

  has_many :player_weapons, class_name: 'Player::Weapon::Base', dependent: :destroy
end
