class Game::Armor::Body < Game::Armor::Base
  def equip
    self.slot = player.body_slot

    save
  end

  def equiped?
    slot == player.body_slot
  end
end
