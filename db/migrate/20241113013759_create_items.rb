class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items, id: :uuid do |t|
      t.timestamps
      t.string :type, default: "Item::Base"
      t.string :name
    end
  end
end
