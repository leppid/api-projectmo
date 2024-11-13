class Armor::Base < ApplicationRecord
  self.table_name = 'armors'
  has_and_belongs_to_many :players, join_table: :players_armors, foreign_key: :armor_id, association_foreign_key: :player_id
end
