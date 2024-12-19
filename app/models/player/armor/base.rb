class Player::Armor::Base < ApplicationRecord
  TYPES = ['Player::Armor::Base', 'Player::Armor::Head', 'Player::Armor::Body', 'Player::Armor::Legs']

  self.table_name = 'player_armors'

  belongs_to :game_armor, class_name: 'Game::Armor::Base'
  belongs_to :player, optional: true

  before_save :set_parent_type

  def name
    game_armor.name
  end

  def equiped?
    case type
    when TYPES[1]
      player.head_armor_id == id
    when TYPES[2]
      player.body_armor_id == id
    when TYPES[3]
      player.legs_armor_id == id
    else
      false
    end
  end

  private

  def set_parent_type
    self.type = game_armor.type.gsub!('Game', 'Player')
  end
end
