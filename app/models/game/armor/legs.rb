class Game::Armor::Legs < Game::Armor::Base
  belongs_to :legs_slot, class_name: 'Player', optional: true

  def equip
    update_columns(legs_slot_id: player_id, player_id: nil)
  end

  def unequip
    update_columns(legs_slot_id: nil, player_id: legs_slot_id)
  end
end
