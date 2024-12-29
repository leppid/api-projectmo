class InventoryBlueprint < Blueprinter::Base
  fields :id, :name, :index

  field :type do |obj|
    obj.type.split('::').last
  end
end
