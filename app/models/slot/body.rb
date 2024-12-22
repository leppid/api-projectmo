class Slot::Body < Slot::Base
  has_one :body_armor, class_name: 'Game::Armor::Body', foreign_key: :body_slot_id, dependent: :destroy
end
