class InventoryController < ApplicationController
  expose :player, -> { current_player }

  def index
    render json: InventoryBlueprint.render(player.stuff), status: :ok
  end

  def sync_inventory
    return head :bad_request if inventory_params[:data].nil?

    inventory_params[:data].each do |data|
      item = player.stuff.find_by(id: data[:id])
      slot = player.slots.find_by(index: data[:index])

      next if item.nil? || slot.nil?

      item.update(slot: slot)
    end

    head :ok
  end

  private

  def inventory_params
    params.permit(data: %i[id name type index])
  end
end
