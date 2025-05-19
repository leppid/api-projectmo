class AddAuthTokenToPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :auth_token, :string
  end
end
