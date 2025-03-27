class CreateDraftArmors < ActiveRecord::Migration[8.0]
  def change
    create_table :draft_armors, id: :uuid do |t|
      t.timestamps
      t.string :type, default: "Draft::Armor::Base"
      t.string :name
      t.string :model
      t.boolean :disable_head, default: false
      t.boolean :disable_body, default: false
      t.boolean :disable_arms, default: false
      t.boolean :disable_legs, default: false
      t.boolean :test, default: false
    end
  end
end
