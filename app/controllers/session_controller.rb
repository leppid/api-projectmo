class SessionController < ApplicationController
  expose :player, -> { Player.find_by(login: params[:login]) }

  def create
    if player&.authenticate(params[:password])
      render json: player.as_json, status: :ok
    else
      render json: { message: 'Invalid Login or Password' }, status: :unauthorized
    end
  end
end
