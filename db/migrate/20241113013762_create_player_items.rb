class CreatePlayerItems < ActiveRecord::Migration[8.0]
  def change
    create_table :player_items, id: :uuid do |t|
      t.timestamps
      t.string :type, default: "Player::Item::Base"
      t.uuid :game_item_id
      t.uuid :player_id
    end
  end
end
