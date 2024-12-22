class CreateGameWeapons < ActiveRecord::Migration[8.0]
  def change
    create_table :game_weapons, id: :uuid do |t|
      t.string :type, default: "Game::Weapon::Base"
      t.uuid :draft_weapon_id
      t.uuid :primary_slot_id
      t.uuid :secondary_slot_id
      t.timestamps
    end
  end
end
