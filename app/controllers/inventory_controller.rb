class InventoryController < ApplicationController
  expose :player, -> { current_player }

  def index
    render json: InventoryBlueprint.render(player.stuff), status: :ok
  end

  def update
    item = player.stuff.find_by(id: inventory_params[:id])
    slot = player.slots.find_by(index: inventory_params[:index])

    return head :not_found if item.nil? || slot.nil?

    slot.content&.update(slot: item.slot)

    head :ok if item.update(slot: slot)
  end

  private

  def inventory_params
    params.require(:inventory).permit(:id, :index)
  end
end
