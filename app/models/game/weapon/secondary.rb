class Game::Weapon::Secondary < Game::Weapon::Base
  has_one :secondary_slot, class_name: 'Player', foreign_key: 'secondary_weapon_id'

  def equip
    player.update_column(:secondary_weapon_id, id)
  end

  def unequip
    player&.update_column(:secondary_weapon_id, nil)
  end
end
