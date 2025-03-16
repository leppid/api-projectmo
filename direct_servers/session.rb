class Session
  attr_accessor :id, :pid, :time

  def initialize(params = {})
    @id = SecureRandom.uuid
    @pid = params[:pid]
    touch
  end

  def touch
    @time = Time.now
  end
end
