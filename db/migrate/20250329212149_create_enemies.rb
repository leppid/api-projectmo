class CreateEnemies < ActiveRecord::Migration[8.0]
  def change
    create_table :enemies, id: :uuid do |t|
      t.string :name
      t.string :model
      t.float :health
      t.float :armor
      t.float :min_damage
      t.float :max_damage
      t.float :crit_multiplier
      t.float :crit_chance

      t.timestamps
    end
  end
end
