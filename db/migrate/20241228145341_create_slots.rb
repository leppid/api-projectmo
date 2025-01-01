class CreateSlots < ActiveRecord::Migration[8.0]
  def change
    create_table :slots, id: :uuid do |t|
      t.string :type, default: "Slot::Base"
      t.uuid :player_id
      t.integer :index
      t.timestamps
    end
  end
end
