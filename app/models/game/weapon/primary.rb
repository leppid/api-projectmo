class Game::Weapon::Primary < Game::Weapon::Base
  def equip
    self.slot = player.primary_slot

    save
  end

  def equiped?
    slot == player.primary_slot
  end
end
