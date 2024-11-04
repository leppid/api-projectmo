class AuthController < ApplicationController
  def create
    @player = Player.find_by(login: params[:login])

    if @player && @player.authenticate(params[:password])
      render json: @player
    else
      render json: @player.errors.full_messages, status: :unauthorized
    end
  end
end
