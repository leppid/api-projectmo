class Game::Armor::Legs < Game::Armor::Base
  has_one :legs_slot, class_name: 'Player', foreign_key: 'legs_armor_id'

  def equip
    clear_slot

    player&.update_column(:legs_armor_id, id)
  end

  def unequip
    return unless assign_slot

    player&.update_column(:legs_armor_id, nil)
  end
end
