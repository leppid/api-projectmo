class CreateDraftItems < ActiveRecord::Migration[8.0]
  def change
    create_table :draft_items, id: :uuid do |t|
      t.string :type, default: "Draft::Item::Base"
      t.string :name
      t.timestamps
    end
  end
end
