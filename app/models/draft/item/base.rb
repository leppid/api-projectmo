class Draft::Item::Base < ApplicationRecord
  TYPES = ['Draft::Item::Quest']

  self.table_name = 'draft_items'

  has_many :game_items, class_name: 'Game::Item::Base', dependent: :destroy
end
