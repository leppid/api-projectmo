class CreateGameArmors < ActiveRecord::Migration[8.0]
  def change
    create_table :game_armors, id: :uuid do |t|
      t.timestamps
      t.string :type, default: "Game::Armor::Base"
      t.uuid :draft_armor_id
      t.uuid :player_id
    end
  end
end
