class CreateBagSlots < ActiveRecord::Migration[8.0]
  def change
    create_table :bag_slots, id: :uuid do |t|
      t.uuid :player_id
      t.uuid :bagable_id
      t.string :bagable_type
      t.timestamps
    end
  end
end
