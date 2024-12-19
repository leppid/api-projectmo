class CreatePlayerArmors < ActiveRecord::Migration[8.0]
  def change
    create_table :player_armors, id: :uuid do |t|
      t.timestamps
      t.string :type, default: "Player::Armor::Base"
      t.uuid :game_armor_id
      t.uuid :player_id
    end
  end
end
