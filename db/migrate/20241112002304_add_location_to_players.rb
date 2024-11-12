class AddLocationToPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :location, :string
  end
end
