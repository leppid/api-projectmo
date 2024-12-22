class CreateEquipSlots < ActiveRecord::Migration[8.0]
  def change
    create_table :equip_slots, id: :uuid do |t|
      t.uuid :player_id
      t.timestamps
    end
  end
end
