class Slot::Primary < Slot::Base
  has_one :primary_weapon, class_name: 'Game::Weapon::Primary', foreign_key: :primary_slot_id, dependent: :destroy
end
