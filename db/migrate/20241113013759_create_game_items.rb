class CreateGameItems < ActiveRecord::Migration[8.0]
  def change
    create_table :game_items, id: :uuid do |t|
      t.timestamps
      t.string :type, default: "Gmae::Item::Base"
      t.string :name
    end
  end
end
