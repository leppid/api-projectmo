module Spawnable
  extend ActiveSupport::Concern

  included do
    attr_accessor :player_id

    after_update :spawn
  end

  def spawn
    return if player_id.blank?

    spawn_for(Player.find(player_id))
  end

  def spawn_for(player)
    return unless player

    self.class.to_s.gsub('Draft', 'Game').constantize.create(draft_armor: self, player: player)
  end
end
