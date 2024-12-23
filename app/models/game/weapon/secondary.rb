class Game::Weapon::Secondary < Game::Weapon::Base
  belongs_to :secondary_slot, class_name: 'Player', optional: true

  def equip
    update_columns(secondary_slot_id: player_id, player_id: nil)
  end

  def unequip
    update_columns(secondary_slot_id: nil, player_id: secondary_slot_id)
  end
end
