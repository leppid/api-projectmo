class BattleMember
  attr_accessor :bot, :team, :index, :status, :id, :name, :model, :models, :helath, :armor, :max_damage, :min_damage, :crit_multiplier, :crit_chance, :time

  def initialize(params = {})
    @bot = params[:bot]
    @team = params[:team]
    @index = params[:index]
    @status = :alive
    @id = params[:id]
    @name = params[:name]
    @model = params[:model]
    @models = params[:models]
    @helath = params[:helath]
    @armor = params[:armor]
    @max_damage = params[:max_damage]
    @min_damage = params[:min_damage]
    @crit_multiplier = params[:crit_multiplier]
    @crit_chance = params[:crit_chance]
    @time = Time.now
  end
end
