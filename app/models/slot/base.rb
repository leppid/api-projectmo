class Slot::Base < ApplicationRecord
  TYPES = ['Slot::Head', 'Slot::Body', 'Slot::Legs', 'Slot::Primary', 'Slot::Secondary']

  self.table_name = 'equip_slots'

  belongs_to :player
end
