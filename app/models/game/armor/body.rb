class Game::Armor::Body < Game::Armor::Base
  has_one :body_slot, class_name: 'Player', foreign_key: 'body_armor_id'

  def equip
    clear_slot

    player&.update_column(:body_armor_id, id)
  end

  def unequip
    return unless assign_slot

    player&.update_column(:body_armor_id, nil)
  end
end
