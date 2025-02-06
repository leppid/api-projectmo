class Draft::Armor::Base < ApplicationRecord
  include Spawnable

  TYPES = ['Draft::Armor::Head', 'Draft::Armor::Body', 'Draft::Armor::Legs']

  self.table_name = 'draft_armors'

  has_many :game_armors, class_name: 'Game::Armor::Base', foreign_key: :draft_armor_id, dependent: :destroy
end
