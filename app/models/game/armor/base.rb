class Game::Armor::Base < ApplicationRecord
  TYPES = ['Game::Armor::Head', 'Game::Armor::Body', 'Game::Armor::Legs']

  self.table_name = 'game_armors'

  attr_accessor :bag_slot_id

  belongs_to :draft_armor, class_name: 'Draft::Armor::Base'

  has_one :bag_slot, class_name: 'Slot::Bag', as: :bagable

  belongs_to :head_slot, class_name: 'Slot::Head', optional: true
  belongs_to :body_slot, class_name: 'Slot::Body', optional: true
  belongs_to :legs_slot, class_name: 'Slot::Legs', optional: true

  before_save :set_parent_type, :set_bag_slot

  before_destroy :unset_slots

  scope :player_id_eq, ->(value) { left_outer_joins(:bag_slot, :head_slot, :body_slot, :legs_slot).where('bag_slots.player_id = :value OR equip_slots.player_id = :value', { value: value }) }

  def self.ransackable_scopes(_auth_object = nil)
    %i[player_id_eq]
  end

  def name
    draft_armor.name
  end

  def player
    bag_slot&.player || head_slot&.player || body_slot&.player || legs_slot&.player
  end

  def equiped?
    case type
    when TYPES[0]
      head_slot.present?
    when TYPES[1]
      body_slot.present?
    when TYPES[2]
      legs_slot.present?
    else
      false
    end
  end

  def equip
    raise ArgumentError, 'Player is not present' unless player.present?
  end

  def unequip
    raise ArgumentError, 'Player is not present' unless player.present?

    raise ArgumentError, 'Player has no empty bag slot' unless player.first_empty_bag_slot.present?
  end

  def place_in_slot(slot)
    case slot.class
    when Slot::Bag
      unset_slots
      self.bag_slot = slot
    when Slot::Head
      self.primary_slot = slot
    when Slot::Body
      self.secondary_slot = slot
    when Slot::Legs
      self.head_slot = slot
    else
      raise ArgumentError 'Invalid slot type'
    end
  end

  private

  def set_parent_type
    self.type = draft_weapon.type.gsub!('Draft', 'Game')
  end

  def set_bag_slot_by_id
    return unless bag_slot_id.present?

    unset_slots
    slot = Slot::Bag.find_by(id: bag_slot_id)
    self.bag_slot = slot
  end

  def unset_slots
    bag_slot&.update(bagable_id: nil)
    update_columns(head_slot_id: nil, body_slot_id: nil, legs_slot_id: nil)
  end
end
