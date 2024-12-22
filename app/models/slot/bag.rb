class Slot::Bag < ApplicationRecord
  self.table_name = 'bag_slots'

  belongs_to :player

  belongs_to :bagable, polymorphic: true, optional: true
end
