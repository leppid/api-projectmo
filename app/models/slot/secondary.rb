class Slot::Secondary < Slot::Base
  has_one :secondary_weapon, class_name: 'Game::Weapon::Secondary', foreign_key: :secondary_slot_id, dependent: :destroy
end
