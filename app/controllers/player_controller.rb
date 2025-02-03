class PlayerController < ApplicationController
  expose :player, -> { current_player }
  expose :stuff, -> { player&.stuff&.filter { |item| item.slot.present? } }
  expose :stuff_without_slot, -> { player&.stuff&.filter { |item| item.slot.nil? } }

  def index
    render json: PlayerBlueprint.render(player), status: :ok
  end

  def inventory
    stuff_without_slot.each(&:set_bag_slot)
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
    stuff_without_slot.each(&:set_bag_slot)

    return if player_params[:inventory].blank?

    player_params[:inventory].each do |inv_item|
      item = player.stuff.select { |i| i.id == inv_item[:id] }.first
      slot = player.slots.find_by(index: inv_item[:index])

      puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #{item.blank?} #{slot.blank?}"

      next if item.blank? || slot.blank?

      item.update(slot: slot)
    end

    head :ok
  end

  def player_params
    params.permit(:location, :position, inventory: %i[id name type index model color])
  end
end
