module Itemable
  extend ActiveSupport::Concern

  included do
    belongs_to :player
    belongs_to :slot, class_name: 'Slot::Base', optional: true

    before_validation :assign_bag_slot, on: :create
  end

  def set_bag_slot
    assign_bag_slot
    save
  end

  def assign_bag_slot
    empty_bag_slot = player&.empty_bag_slot

    return errors.add(:player, 'Bag is full') unless empty_bag_slot

    self.slot = empty_bag_slot
  end
end
