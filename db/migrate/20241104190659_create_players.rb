class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players, id: :uuid do |t|
      t.string :display_name
      t.string :login
      t.string :password_digest
      t.string :location
      t.string :position
      t.integer :bag_pages, default: 1
      t.timestamps
    end
  end
end
