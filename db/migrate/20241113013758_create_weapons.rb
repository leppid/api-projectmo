class CreateWeapons < ActiveRecord::Migration[8.0]
  def change
    create_table :weapons, id: :uuid do |t|
      t.timestamps
      t.string :type, default: "Weapon::Base"
      t.string :name
    end
  end
end
