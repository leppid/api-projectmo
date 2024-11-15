class CreateArmors < ActiveRecord::Migration[8.0]
  def change
    create_table :armors, id: :uuid do |t|
      t.timestamps
      t.string :type, default: "Armor::Base"
      t.string :name
    end
  end
end
