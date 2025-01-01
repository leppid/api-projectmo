class Slot::Secondary < Slot::Base
  has_one :secondary_weapon, class_name: 'Game::Weapon::Secondary', foreign_key: :slot_id

  before_validation :assign_index, on: :create

  def content
    secondary_weapon
  end

  def empty?
    !content
  end

  private

  def assign_index
    self.index = -5
  end
end
