class Slot::Body < Slot::Base
  has_one :body_armor, class_name: 'Game::Armor::Body', foreign_key: :slot_id

  before_validation :assign_index, on: :create

  def content
    body_armor
  end

  def empty?
    !content
  end

  private

  def assign_index
    self.index = -2
  end
end
