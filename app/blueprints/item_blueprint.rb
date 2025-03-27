class ItemBlueprint < Blueprinter::Base
  fields :id, :index, :name

  field :type do |obj|
    obj.type.split('::').last
  end

  field :model do |obj|
    ItemModelBlueprint.render_as_json(obj)
  end
end
