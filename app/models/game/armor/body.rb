class Game::Armor::Body < Game::Armor::Base
  def equip
    super

    player.body_armor&.unequip

    update(body_slot: player.body_slot, bag_slot: nil)
  end

  def unequip
    super

    update(body_slot: nil, bag_slot: player.first_empty_bag_slot)
  end
end
