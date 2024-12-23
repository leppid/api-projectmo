class Game::Armor::Body < Game::Armor::Base
  belongs_to :body_slot, class_name: 'Player', optional: true

  def equip
    update_columns(body_slot_id: player_id, player_id: nil)
  end

  def unequip
    update_columns(body_slot_id: nil, player_id: body_slot_id)
  end
end
