class Slot::Bag < Slot::Base
  has_one :weapon, class_name: 'Game::Weapon::Base', foreign_key: :slot_id
  has_one :armor, class_name: 'Game::Armor::Base', foreign_key: :slot_id
  has_one :item, class_name: 'Game::Item::Base', foreign_key: :slot_id

  before_validation :assign_index, on: :create

  def content
    weapon || armor || item
  end

  def empty?
    !content
  end

  private

  def assign_index
    self.index = player.bag_slots.count
  end
end
