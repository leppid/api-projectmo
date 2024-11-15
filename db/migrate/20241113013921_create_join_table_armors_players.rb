class CreateJoinTableArmorsPlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players_armors, id: :uuid do |t|
      t.timestamps
      t.uuid "player_id", null: false
      t.uuid "armor_id", null: false
    end
  end
end
