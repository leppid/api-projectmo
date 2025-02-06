class Draft::Weapon::Base < ApplicationRecord
  include Spawnable

  TYPES = ['Draft::Weapon::Primary', 'Draft::Weapon::Secondary']

  self.table_name = 'draft_weapons'

  has_many :game_weapons, class_name: 'Game::Weapon::Base', foreign_key: :draft_weapon_id, dependent: :destroy

  def spawn_for(player)
    Game::Weapon::Base.create(draft_weapon: self, player: player)
  end
end
