class Player::Armor::Body < Player::Armor::Base
  def equip
    player&.update_column(:body_armor_id, id)
  end

  def unequip
    player&.update_column(:body_armor_id, nil)
  end
end
