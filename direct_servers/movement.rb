class Movement
  attr_accessor :id, :log, :loc, :pos, :vel, :rot, :models, :time

  def initialize(params = {})
    update(params)
  end

  def update(params)
    @id = params[:id]
    @log = params[:log]
    @loc = params[:loc]
    @pos = params[:pos]
    @vel = params[:vel]
    @rot = params[:rot]
    @models = params[:models]
    @time = Time.now
  end
end
