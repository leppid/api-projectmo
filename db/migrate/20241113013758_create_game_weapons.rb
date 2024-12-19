class CreateGameWeapons < ActiveRecord::Migration[8.0]
  def change
    create_table :game_weapons, id: :uuid do |t|
      t.timestamps
      t.string :type, default: "Game::Weapon::Base"
      t.string :name
    end
  end
end
