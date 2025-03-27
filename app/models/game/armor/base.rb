class Game::Armor::Base < ApplicationRecord
  include Itemable

  TYPES = ['Game::Armor::Head', 'Game::Armor::Body', 'Game::Armor::Legs']

  self.table_name = 'game_armors'

  belongs_to :draft_armor, class_name: 'Draft::Armor::Base'

  before_create :set_parent_type

  def index
    slot&.index
  end

  def name
    draft_armor.name
  end

  def model
    draft_armor.model.downcase
  end

  def disable_head
    draft_armor.disable_head
  end

  def disable_body
    draft_armor.disable_body
  end

  def disable_arms
    draft_armor.disable_arms
  end

  def disable_legs
    draft_armor.disable_legs
  end

  def unequip
    set_bag_slot
  end

  private

  def set_parent_type
    self.type = draft_armor.type.gsub!('Draft', 'Game')
  end
end
