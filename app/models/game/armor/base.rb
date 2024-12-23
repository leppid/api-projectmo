class Game::Armor::Base < ApplicationRecord
  TYPES = ['Game::Armor::Head', 'Game::Armor::Body', 'Game::Armor::Legs']

  self.table_name = 'game_armors'

  belongs_to :draft_armor, class_name: 'Draft::Armor::Base'

  belongs_to :player, optional: true

  before_save :set_parent_type

  def owner
    Player.find_by(id: player_id || head_slot_id || body_slot_id || legs_slot_id)
  end

  def name
    draft_armor.name
  end

  def equiped?
    case type
    when TYPES[0]
      head_slot_id.present?
    when TYPES[1]
      body_slot_id.present?
    when TYPES[2]
      legs_slot_id.present?
    else
      false
    end
  end

  private

  def set_parent_type
    self.type = draft_armor.type.gsub!('Draft', 'Game')
  end
end
