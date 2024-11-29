class SessionController < ApplicationController
  skip_before_action :authenticate_player, only: %i[create]

  expose :player, -> { Player.find_by(login: params[:login].strip.downcase) }

  def index
    render json: PlayerBlueprint.render(current_player), status: :ok
  end

  def create
    if player&.authenticate(params[:password])
      render json: PlayerBlueprint.render_as_json(player).merge(token: encode_auth_token(player)), status: :ok
    else
      render json: { message: 'Invalid Login or Password' }, status: :unauthorized
    end
  end
end
