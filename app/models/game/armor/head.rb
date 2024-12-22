class Game::Armor::Head < Game::Armor::Base
  def equip
    super

    player.head_armor&.unequip

    update(head_slot: player.head_slot, bag_slot: nil)
  end

  def unequip
    super

    update(head_slot: nil, bag_slot: player.first_empty_bag_slot)
  end
end
