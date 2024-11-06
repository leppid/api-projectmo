class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.string :login
      t.string :password_digest
      t.timestamps
    end
  end
end
