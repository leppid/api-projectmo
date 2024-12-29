class Inventory::Slot < ApplicationRecord
  self.table_name = 'inventory_slots'

  belongs_to :grid, class_name: 'Inventory::Grid', foreign_key: :inventory_grid_id

  belongs_to :slotable, polymorphic: true, optional: true

  before_create :set_index

  private

  def set_index
    self.index = grid.slots.count
  end
end
