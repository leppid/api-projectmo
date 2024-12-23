class Game::Item::Base < ApplicationRecord
  TYPES = ['Game::Item::Quest']

  self.table_name = 'game_items'

  belongs_to :draft_item, class_name: 'Draft::Item::Base'
  belongs_to :player, optional: true

  before_save :set_parent_type

  def owner
    Player.find_by(id: player_id)
  end

  def name
    draft_item.name
  end

  private

  def set_parent_type
    self.type = draft_item.type.gsub!('Draft', 'Game')
  end
end
