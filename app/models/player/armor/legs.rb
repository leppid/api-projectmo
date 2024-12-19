class Player::Armor::Legs < Player::Armor::Base
  def equip
    player&.update_column(:legs_armor_id, id)
  end

  def unequip
    player&.update_column(:legs_armor_id, nil)
  end
end
