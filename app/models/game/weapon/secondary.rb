class Game::Weapon::Secondary < Game::Weapon::Base
  def equip
    super

    player.secondary_weapon&.unequip

    update(secondary_slot: player.secondary_slot, bag_slot: nil)
  end

  def unequip
    super

    update(secondary_slot: nil, bag_slot: player.first_empty_bag_slot)
  end
end
