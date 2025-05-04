class BattleController < ApplicationController
  def create
    session_id = nil
    warrior = nil
    enemies = []

    begin
      session_id = params[:session_id]
      warrior = WarriorBlueprint.render_as_json(current_player)
      params[:enemies].each do |enemy_id|
        enemies << EnemyBlueprint.render_as_json(Enemy.find(enemy_id))
      end
      p "enemies: #{enemies}"
    rescue
      return something_went_wrong
    end

    request_string = { action: 'create', Params: { sessionId: session_id, warrior: warrior, enemies: enemies } }.to_msgpack
    p "requestString: #{request_string}"
    battle_socket.puts(request_string)
    battle_socket.puts("\n")
    response = battle_socket.gets

    p "response: #{response}"

    begin
      response = MessagePack.unpack(response)
    rescue
      return something_went_wrong
    end

    if response['status'] == 'success'
      render json: { battle_id: response['battle_id'] }, status: :ok
    else
      something_went_wrong
    end
  end

  def join
    session_id = nil
    battle_id = nil
    warrior = nil

    begin
      session_id = params[:session_id]
      battle_id = params[:battle_id]
      warrior = WarriorBlueprint.render_as_json(current_player)
    rescue
      return something_went_wrong
    end

    battle_socket.puts({ action: 'join', Params: { sessionId: session_id, battleId: battle_id, warrior: warrior } }.to_msgpack)
    response = battle_socket.gets

    begin
      response = MessagePack.unpack(response)
    rescue
      return something_went_wrong
    end

    if response['status'] == 'success'
      render json: { battle_id: response['battle_id'] }, status: :ok
    else
      something_went_wrong
    end
  end

  private

  def battle_create_params
    params.require(:battle).permit(:session_id, enemies: [])
  end

  def battle_join_params
    params.require(:battle).permit(:session_id, :battle_id)
  end

  def something_went_wrong
    render json: { message: 'Something went wrong' }, status: :unprocessable_entity
  end

  def battle_socket
    @battle_socket ||= TCPSocket.new('91.202.145.155', 9003)
  end
end
