class CreateDraftItems < ActiveRecord::Migration[8.0]
  def change
    create_table :draft_items, id: :uuid do |t|
      t.timestamps
      t.string :type, default: "Draft::Item::Base"
      t.string :name
      t.string :description
      t.boolean :test, default: false
    end
  end
end
