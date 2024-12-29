class Game::Weapon::Secondary < Game::Weapon::Base
  def equip
    self.slot = player.secondary_slot

    save
  end

  def equiped?
    slot == player.secondary_slot
  end
end
