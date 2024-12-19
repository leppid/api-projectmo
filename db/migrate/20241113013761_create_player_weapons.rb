class CreatePlayerWeapons < ActiveRecord::Migration[8.0]
  def change
    create_table :player_weapons, id: :uuid do |t|
      t.timestamps
      t.string :type, default: "Player::Weapon::Base"
      t.uuid :game_weapon_id
      t.uuid :player_id
    end
  end
end
