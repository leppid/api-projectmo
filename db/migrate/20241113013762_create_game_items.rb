class CreateGameItems < ActiveRecord::Migration[8.0]
  def change
    create_table :game_items, id: :uuid do |t|
      t.timestamps
      t.string :type, default: "Game::Item::Base"
      t.uuid :draft_item_id
      t.uuid :player_id
      t.uuid :primary_slot_id
      t.uuid :secondary_slot_id
    end
  end
end
