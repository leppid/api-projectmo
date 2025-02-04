class SyncBlueprint < Blueprinter::Base
  fields :id, :login, :display_name, :location, :position, :bag_pages
  association :inventory, blueprint: InventoryBlueprint
end
