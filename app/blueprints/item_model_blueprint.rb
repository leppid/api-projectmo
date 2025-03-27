class ItemModelBlueprint < Blueprinter::Base
  field :name do |obj|
    obj.try(:model)
  end

  field :type do |obj|
    obj.type.split('::').last
  end

  field :disable_head do |obj|
    obj.try(:disable_head) || false
  end

  field :disable_body do |obj|
    obj.try(:disable_body) || false
  end

  field :disable_arms do |obj|
    obj.try(:disable_arms) || false
  end

  field :disable_legs do |obj|
    obj.try(:disable_legs) || false
  end
end
