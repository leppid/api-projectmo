class Item::Base < ApplicationRecord
  TYPES = ['Item::Base']

  self.table_name = 'items'

  has_and_belongs_to_many :players, join_table: :players_items, foreign_key: :item_id, association_foreign_key: :player_id
end
