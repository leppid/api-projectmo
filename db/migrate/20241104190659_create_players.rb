class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players, id: :uuid do |t|
      t.string :display_name
      t.string :login
      t.string :password_digest
      t.string :location
      t.string :position
      t.uuid :helmet_id
      t.uuid :bip_id
      t.uuid :pants_id
      t.uuid :primary_id
      t.uuid :secondary_id
      t.timestamps
    end
  end
end
