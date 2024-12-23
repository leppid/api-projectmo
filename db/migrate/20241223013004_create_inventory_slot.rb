class CreateInventorySlot < ActiveRecord::Migration[8.0]
  def change
    create_table :inventory_slots, id: :uuid do |t|
      t.uuid :inventory_grid_id
      t.uuid :slotable_id
      t.string :slotable_type
      t.integer :index
      t.timestamps
    end
  end
end
