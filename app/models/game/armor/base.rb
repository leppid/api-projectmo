class Game::Armor::Base < ApplicationRecord
  TYPES = ['Game::Armor::Head', 'Game::Armor::Body', 'Game::Armor::Legs']

  self.table_name = 'game_armors'

  belongs_to :draft_armor, class_name: 'Draft::Armor::Base'
  belongs_to :player, class_name: 'Player', optional: true

  has_one :slot, as: :slotable, class_name: 'Inventory::Slot'

  validate :slot_availablity, on: :create

  before_create :set_parent_type, :assing_slot_callback

  before_destroy :clear_slot

  def name
    draft_armor.name
  end

  def equiped?
    case type
    when TYPES[0]
      player&.head_armor_id == id
    when TYPES[1]
      player&.body_armor_id == id
    when TYPES[2]
      player&.legs_armor_id == id
    else
      false
    end
  end

  def slot_availablity
    return errors.add(:base, 'Player not found') if player.nil?

    errors.add(:base, 'No available slots') if player.first_empty_slot.nil?
  end

  def assing_slot_callback
    return if player.nil?

    first_empty_slot = player.first_empty_slot

    return if first_empty_slot.nil?

    self.slot = first_empty_slot
  end

  def assign_slot
    assing_slot_callback

    save(validate: false)
  end

  def clear_slot
    self.slot = nil

    save(validate: false)
  end

  private

  def set_parent_type
    self.type = draft_armor.type.gsub!('Draft', 'Game')
  end
end
