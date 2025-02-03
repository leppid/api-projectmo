class Game::Weapon::Base < ApplicationRecord
  include Itemable

  TYPES = ['Game::Weapon::Primary', 'Game::Weapon::Secondary']

  self.table_name = 'game_weapons'

  belongs_to :draft_weapon, class_name: 'Draft::Weapon::Base'

  before_create :set_parent_type

  def model
    draft_weapon.model.downcase
  end

  def index
    slot&.index
  end

  def name
    draft_weapon.name
  end

  def unequip
    set_bag_slot
  end

  private

  def set_parent_type
    self.type = draft_weapon.type.gsub!('Draft', 'Game')
  end
end
