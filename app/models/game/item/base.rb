class Game::Item::Base < ApplicationRecord
  TYPES = ['Game::Item::Base']

  self.table_name = 'game_items'

  attr_accessor :bag_slot_id

  belongs_to :draft_item, class_name: 'Draft::Item::Base'

  has_one :bag_slot, class_name: 'Slot::Bag', as: :bagable

  before_save :set_parent_type, :set_bag_slot_by_id

  before_destroy :unset_slots

  scope :player_id_eq, ->(value) { left_outer_joins(:bag_slot).where('bag_slots.player_id = :value', { value: value }) }

  def self.ransackable_scopes(_auth_object = nil)
    %i[player_id_eq]
  end

  def name
    draft_item.name
  end

  def player
    bag_slot&.player
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
  end
end
