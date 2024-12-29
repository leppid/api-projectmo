class Slot::Base < ApplicationRecord
  self.table_name = 'slots'

  validates :index, uniqueness: true

  belongs_to :player
end
