class SyncBlueprint < Blueprinter::Base
  fields :id, :login, :display_name, :location, :position, :bag_pages, :auth_token
  association :inventory, blueprint: ItemBlueprint
end
