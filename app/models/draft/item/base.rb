class Draft::Item::Base < ApplicationRecord
  include Spawnable

  TYPES = ['Draft::Item::Quest']

  self.table_name = 'draft_items'

  has_many :game_items, class_name: 'Game::Item::Base', foreign_key: :draft_item_id, dependent: :destroy

  def spawn_for(player)
    Game::Item::Base.create(draft_item: self, player: player)
  end
end
