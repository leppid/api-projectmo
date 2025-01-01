class Draft::Weapon::Base < ApplicationRecord
  TYPES = ['Draft::Weapon::Primary', 'Draft::Weapon::Secondary']

  self.table_name = 'draft_weapons'

  has_many :game_weapons, class_name: 'Game::Weapon::Base', dependent: :destroy

  def generate_for(player)
    Game::Weapon::Base.create(draft_item: self, player: player)
  end
end
