class Game::Armor::Head < Game::Armor::Base
  def equip
    self.slot = player.head_slot

    save
  end

  def equiped?
    slot == player.head_slot
  end
end
