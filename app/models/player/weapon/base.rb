class Player::Weapon::Base < ApplicationRecord
  TYPES = ['Player::Weapon::Base', 'Player::Weapon::Primary', 'Player::Weapon::Secondary']

  self.table_name = 'player_weapons'

  belongs_to :game_weapon, class_name: 'Game::Weapon::Base'
  belongs_to :player, optional: true

  before_save :set_parent_type

  def name
    game_weapon.name
  end

  def equiped?
    case type
    when TYPES[1]
      player.primary_weapon_id == id
    when TYPES[2]
      player.secondary_weapon_id == id
    else
      false
    end
  end

  private

  def set_parent_type
    self.type = game_weapon.type.gsub!('Game', 'Player')
  end
end
