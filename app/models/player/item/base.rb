class Player::Item::Base < ApplicationRecord
  TYPES = ['Player::Item::Base']

  self.table_name = 'player_items'

  belongs_to :game_item, class_name: 'Game::Item::Base'
  belongs_to :player, optional: true

  before_save :set_parent_type

  def name
    game_item.name
  end

  private

  def set_parent_type
    self.type = game_item.type.gsub!('Game', 'Player')
  end
end
