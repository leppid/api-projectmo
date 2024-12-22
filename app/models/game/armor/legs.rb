class Game::Armor::Legs < Game::Armor::Base
  def equip
    super

    player.legs_armor&.unequip

    update(legs_slot: player.legs_slot, bag_slot: nil)
  end

  def unequip
    super

    update(legs_slot: nil, bag_slot: player.first_empty_bag_slot)
  end
end
