class InventoryBlueprint < Blueprinter::Base
  fields :id, :name, :model, :index

  field :type do |obj|
    obj.type.split('::').last
  end
end
