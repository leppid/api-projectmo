class CreateGameItems < ActiveRecord::Migration[8.0]
  def change
    create_table :game_items, id: :uuid do |t|
      t.string :type, default: "Game::Item::Base"
      t.uuid :draft_item_id
      t.timestamps
    end
  end
end
