class Session
  attr_accessor :id, :player_id, :time

  def initialize(params = {})
    @id = SecureRandom.uuid
    @player_id = params[:player_id]
    touch
  end

  def touch
    @time = Time.now
  end
end
