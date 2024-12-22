class Game::Weapon::Primary < Game::Weapon::Base
  def equip
    super

    player.primary_weapon&.unequip

    update(primary_slot: player.primary_slot, bag_slot: nil)
  end

  def unequip
    super

    update(primary_slot: nil, bag_slot: player.first_empty_bag_slot)
  end
end
