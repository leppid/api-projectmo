class Slot::Head < Slot::Base
  has_one :head_armor, class_name: 'Game::Armor::Head', foreign_key: :head_slot_id, dependent: :destroy
end
