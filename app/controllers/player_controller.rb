class PlayerController < ApplicationController
  expose :player, -> { current_player }

  def sync_position
    player.update(player_params)

    return render json: PlayerBlueprint.render(player), status: :ok unless player.errors.any?

    render json: { message: player.errors.full_messages[0] }, status: :unprocessable_entity
  end

  private

  def player_params
    params.permit(:login, :location, :position)
  end
end
