class Game::Item::Base < ApplicationRecord
  include Itemable

  TYPES = ['Game::Item::Quest']

  self.table_name = 'game_items'

  belongs_to :draft_item, class_name: 'Draft::Item::Base'

  before_create :set_parent_type

  def index
    slot&.index
  end

  def name
    draft_item.name
  end

  private

  def set_parent_type
    self.type = draft_item.type.gsub!('Draft', 'Game')
  end
end
