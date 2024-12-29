class Game::Armor::Legs < Game::Armor::Base
  def equip
    self.slot = player.legs_slot

    save
  end

  def equiped?
    slot == player.legs_slot
  end
end
