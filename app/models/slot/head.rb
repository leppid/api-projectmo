class Slot::Head < Slot::Base
  has_one :head_armor, class_name: 'Game::Armor::Head', foreign_key: :slot_id

  before_validation :assign_index, on: :create

  def content
    head_armor
  end

  def empty?
    !content
  end

  private

  def assign_index
    self.index = -1
  end
end
