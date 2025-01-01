class ApplicationController < ActionController::Base
  protect_from_forgery

  wrap_parameters false

  before_action :authenticate_player

  def current_player
    return if decoded_auth_token.blank?

    return if token_expired?

    @current_player ||= Player.find(decoded_auth_token['player_id'])
  end

  def authenticate_player
    render json: { message: 'Not Authorized' }, status: :unauthorized unless current_player
  end

  def encode_auth_token(player)
    JWT.encode({ player_id: player.id, expire: 1.month.from_now }.to_json, ENV['JWT_SECRET'])
  end

  private

  def decoded_auth_token
    header = request.headers['Authorization']
    return unless header

    token = header.split(' ')[1]

    @decoded_auth_token ||= JSON.parse(JWT.decode(token, ENV['JWT_SECRET'])[0])
  rescue JWT::DecodeError
    nil
  end

  def token_expired?
    return true if decoded_auth_token['expire'].blank?

    decoded_auth_token['expire'].to_datetime < DateTime.now
  end
end
