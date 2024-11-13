class CreateJoinTableItemsPlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players_items, id: false do |t|
      t.uuid "player_id", null: false
      t.uuid "item_id", null: false
    end
  end
end
