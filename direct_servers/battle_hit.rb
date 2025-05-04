class BattleHit
  attr_accessor :id, :battle_id, :attacker_id, :defender_id, :damage, :time

  def initialize(params = {})
    @id = SecureRandom.uuid
    @battle_id = params[:battle_id]
    @attacker_id = params[:attacker_id]
    @defender_id = params[:defender_id]
    @damage = params[:damage]
    @time = Time.now
  end
end
