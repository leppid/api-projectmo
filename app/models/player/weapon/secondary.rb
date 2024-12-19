class Player::Weapon::Secondary < Player::Weapon::Base
  def equip
    player&.update_column(:secondary_weapon_id, id)
  end

  def unequip
    player&.update_column(:secondary_weapon_id, nil)
  end
end
