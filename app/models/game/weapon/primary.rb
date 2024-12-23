class Game::Weapon::Primary < Game::Weapon::Base
  belongs_to :primary_slot, class_name: 'Player', optional: true

  def equip
    update_columns(primary_slot_id: player_id, player_id: nil)
  end

  def unequip
    update_columns(primary_slot_id: nil, player_id: primary_slot_id)
  end
end
