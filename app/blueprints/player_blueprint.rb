class PlayerBlueprint < Blueprinter::Base
  fields :id, :login, :display_name, :location, :position, :head_armor, :body_armor, :legs_armor, :primary_weapon, :secondary_weapon, :inventory
end
