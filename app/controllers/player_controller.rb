class PlayerController < ApplicationController
  expose :player, -> { current_user }

  def update
    player.update(player_params)
    return render json: player.errors.full_messages, status: :bad_request if player.errors.any?

    render json: player.as_json, status: :ok
  end

  private

  def player_params
    params.require(:player).permit(:login, :location, :position)
  end
end
