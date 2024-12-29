class Slot::Legs < Slot::Base
  has_one :legs_armor, class_name: 'Game::Armor::Legs', foreign_key: :slot_id

  before_validation :assign_index, on: :create

  def content
    legs_armor
  end

  def empty?
    !content
  end

  private

  def assign_index
    self.index = -3
  end
end
