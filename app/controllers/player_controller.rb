class PlayerController < ApplicationController
  expose :player, -> { current_player }
  expose :inventory, -> { player&.inventory_with_slot }
  expose :inventory_without_slot, -> { player&.inventory_without_slot }

  def index
    render json: SyncBlueprint.render(player), status: :ok
  end

  def sync
    sync_position
    sync_inventory

    render json: SyncBlueprint.render(player), status: :ok
  end

  private

  def sync_position
    return if params[:location].blank? || params[:position].blank?

    player.update(location: params[:location], position: params[:position])
  end

  def sync_inventory
    return if params[:inventory].blank?

    params[:inventory].each do |inv_item|
      item = player.inventory.select { |i| i.id == inv_item[:id] }.first
      slot = player.slots.find_by(index: inv_item[:index])

      next if item.blank? || slot.blank?

      item.update(slot: slot)
    end

    inventory_without_slot.each(&:set_bag_slot)
  end
end
