class Player::Weapon::Primary < Player::Weapon::Base
  def equip
    player&.update_column(:primary_weapon_id, id)
  end

  def unequip
    player&.update_column(:primary_weapon_id, nil)
  end
end
