class CreateDraftWeapons < ActiveRecord::Migration[8.0]
  def change
    create_table :draft_weapons, id: :uuid do |t|
      t.timestamps
      t.string :type, default: "Draft::Weapon::Base"
      t.string :name
      t.string :model
    end
  end
end
