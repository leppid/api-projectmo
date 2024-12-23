class Game::Armor::Head < Game::Armor::Base
  belongs_to :head_slot, class_name: 'Player', optional: true

  def equip
    update_columns(head_slot_id: player_id, player_id: nil)
  end

  def unequip
    update_columns(head_slot_id: nil, player_id: head_slot_id)
  end
end
