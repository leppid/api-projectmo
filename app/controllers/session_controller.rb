class SessionController < ApplicationController
  skip_before_action :authenticate_player, only: %i[create]

  expose :player, -> { Player.find_by(login: params[:login].strip.downcase) }

  def index
    return render json: { message: 'Unauthorized' }, status: :unauthorized unless current_player

    render json: SyncBlueprint.render(current_player), status: :ok
  end

  def create
    if player&.authenticate(params[:password])
      render json: SyncBlueprint.render_as_json(player).merge(token: encode_auth_token(player)), status: :ok
    else
      render json: { message: 'Invalid login or password' }, status: :unauthorized
    end
  end
end
