class Game::Weapon::Base < ApplicationRecord
  TYPES = ['Game::Weapon::Primary', 'Game::Weapon::Secondary']

  self.table_name = 'game_weapons'

  belongs_to :draft_weapon, class_name: 'Draft::Weapon::Base'
  belongs_to :player, optional: true

  before_save :set_parent_type

  def owner
    Player.find_by(id: player_id || primary_slot_id || secondary_slot_id)
  end

  def name
    draft_weapon.name
  end

  def equiped?
    case type
    when TYPES[0]
      primary_slot_id.present?
    when TYPES[1]
      secondary_slot_id.present?
    else
      false
    end
  end

  private

  def set_parent_type
    self.type = draft_weapon.type.gsub!('Draft', 'Game')
  end
end
