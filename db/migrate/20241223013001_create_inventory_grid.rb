class CreateInventoryGrid < ActiveRecord::Migration[8.0]
  def change
    create_table :inventory_grids, id: :uuid do |t|
      t.uuid :player_id
      t.timestamps
    end
  end
end
