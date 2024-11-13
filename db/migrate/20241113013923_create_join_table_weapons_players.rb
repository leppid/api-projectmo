class CreateJoinTableWeaponsPlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players_weapons, id: false do |t|
      t.uuid "player_id", null: false
      t.uuid "weapon_id", null: false
    end
  end
end
