class Battle
  attr_accessor :id, :status, :blue_team, :red_team, :current_blue, :current_red, :current_move, :previous_move, :hits, :time

  def initialize(params = {})
    @id = SecureRandom.uuid
    @status = :in_progress
    @blue_team = params[:blue_team]
    @red_team = params[:red_team]
    @current_blue = blue_team[0]
    @current_red =  red_team[0]
    @current_move = rand(0..1) == 0 ? current_blue : current_red
    @previous_move = nil
    @hits = []
    @time = Time.now
  end

  def touch
    @time = Time.now
  end

  def hit(attacker_id, defender_id)
    attacker = blue_team.find { |a| a.id == attacker_id } || red_team.find { |a| a.id == attacker_id }
    defender = blue_team.find { |d| d.id == defender_id } || red_team.find { |d| d.id == defender_id }

    return self if attacker.nil? || defender.nil?

    damage = rand(attacker.min_damage..attacker.max_damage)
    crit = rand(1..100) <= attacker.crit_chance
    damage *= attacker.crit_multiplier if crit
    reduce = defender.armor / 100
    damage -= (damage * reduce) / 100
    defender.health -= damage

    hits << BattleHit.new(battle_id: id, attacker_id: attacker.id, defender_id: defender.id, damage: damage)

    if defender.health <= 0
      defender.health = 0
      defender.status = :dead
    end

    case defender.team
    when :blue
      blue_team.reject { |b| b.id == defender.id }.push(defender)
    when :red
      red_team.reject { |r| r.id == defender.id }.push(defender)
    end

    self
  end

  def next_move # rubocop:disable Metrics/MethodLength
    if blue_team.sum(&:health).zero? || red_team.sum(&:health).zero?
      @status = :finished
      return
    end

    case current_move.team
    when :blue
      if previous_move == current_red
        @current_blue = current_blue.index == blue_team.length - 1 ? blue_team.select(&:alive)[0] : blue_team.select(&:alive)[current_blue.index + 1]
        @current_red = current_red.index == red_team.length - 1 ? red_team.select(&:alive)[0] : red_team.select(&:alive)[current_red.index + 1]
      end
      @previous_move = current_move
      @current_move = current_red
      if current_move.bot?
        sleep 5
        hit(current_move.id, current_blue.id)
      end
    when :red
      if previous_move == current_blue
        @current_blue = current_blue.index == blue_team.length - 1 ? blue_team.select(&:alive)[0] : blue_team.select(&:alive)[current_blue.index + 1]
        @current_red = current_red.index == red_team.length - 1 ? red_team.select(&:alive)[0] : red_team.select(&:alive)[current_red.index + 1]
      end
      @previous_move = current_move
      @current_move = current_blue
      if current_move.bot?
        sleep 5
        hit(current_move.id, current_red.id)
      end
    end
  end
end
