class Game::Armor::Head < Game::Armor::Base
  has_one :head_slot, class_name: 'Player', foreign_key: 'head_armor_id'

  def equip
    clear_slot

    player&.update_column(:head_armor_id, id)
  end

  def unequip
    return unless assign_slot

    player&.update_column(:head_armor_id, nil)
  end
end
