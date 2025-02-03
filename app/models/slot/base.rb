class Slot::Base < ApplicationRecord
  self.table_name = 'slots'

  belongs_to :player
end
