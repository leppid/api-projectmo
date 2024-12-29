class Draft::Armor::Base < ApplicationRecord
  TYPES = ['Draft::Armor::Head', 'Draft::Armor::Body', 'Draft::Armor::Legs']

  self.table_name = 'draft_armors'

  has_many :game_armors, class_name: 'Game::Armor::Base', dependent: :destroy

  def generate_for(player)
    Game::Armor::Base.create(draft_armor: self, player: player)
  end
end
