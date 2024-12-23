class Game::Weapon::Primary < Game::Weapon::Base
  has_one :primary_slot, class_name: 'Player', foreign_key: 'primary_weapon_id'

  def equip
    player.update_column(:primary_weapon_id, id)
  end

  def unequip
    player&.update_column(:primary_weapon_id, nil)
  end
end
