class Slot::Legs < Slot::Base
  has_one :legs_armor, class_name: 'Game::Armor::Legs', foreign_key: :legs_slot_id, dependent: :destroy
end
