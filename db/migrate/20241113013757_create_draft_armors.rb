class CreateDraftArmors < ActiveRecord::Migration[8.0]
  def change
    create_table :draft_armors, id: :uuid do |t|
      t.timestamps
      t.string :type, default: "Draft::Armor::Base"
      t.string :name
    end
  end
end
