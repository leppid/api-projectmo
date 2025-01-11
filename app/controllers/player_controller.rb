class PlayerController < ApplicationController
  expose :player, -> { current_player }
  expose :stuff, -> { player&.stuff&.filter { |item| item.slot.present? } }
  expose :stuff_without_slot, -> { player&.stuff&.filter { |item| item.slot.nil? } }

  def index
    render json: PlayerBlueprint.render(player), status: :ok
  end

  def inventory
    render json: InventoryBlueprint.render(stuff), status: :ok
  end

  def sync
    sync_position
    sync_inventory

    head :ok
  end

  private

  def sync_position
    return if player_params[:location].blank? || player_params[:position].blank?

    player.update(location: player_params[:location], position: player_params[:position])
  end

  def sync_inventory
    return if player_params[:inventory].blank?

    player_params[:inventory].each do |inv_item|
      item = player.stuff.select { |i| i.id == inv_item[:id] }.first
      slot = player.slots.find_by(index: inv_item[:index])

      next if item.blank? || slot.blank?

      item.update(slot: slot)
    end

    stuff_without_slot.each(&:set_bag_slot)

    head :ok
  end

  def player_params
    params.permit(:location, :position, inventory: %i[id name type index])
  end
end
