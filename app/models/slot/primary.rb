class Slot::Primary < Slot::Base
  has_one :primary_weapon, class_name: 'Game::Weapon::Primary', foreign_key: :slot_id

  before_validation :assign_index, on: :create

  def content
    primary_weapon
  end

  def empty?
    !content
  end

  private

  def assign_index
    self.index = -4
  end
end
