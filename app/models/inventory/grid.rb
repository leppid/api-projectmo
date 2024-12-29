class Inventory::Grid < ApplicationRecord
  self.table_name = 'inventory_grids'

  belongs_to :player, class_name: 'Player'

  has_many :slots, class_name: 'Inventory::Slot', foreign_key: :inventory_grid_id, dependent: :destroy

  after_create :create_page

  def create_page
    12.times do
      slots.create
    end
  end

  def first_empty_slot
    slots.find_by(slotable_id: nil)
  end
end
