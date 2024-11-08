class SessionController < ApplicationController
  expose :player, -> { Player.find_by(login: params[:login]) }

  skip_before_action :authenticate_user!, only: [:create]

  def index
    render json: current_user.as_json, status: :ok
  end

  def create
    if player&.authenticate(params[:password])
      render json: player.as_json.merge({ token: encode_auth_token(player) }), status: :ok
    else
      render json: { message: 'Invalid Login or Password' }, status: :unauthorized
    end
  end
end
