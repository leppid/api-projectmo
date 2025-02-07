class CreateServer < ActiveRecord::Migration[8.0]
  def change
    create_table :servers, id: :uuid do |t|
      t.boolean :open, default: true
      t.timestamps
    end
  end
end
