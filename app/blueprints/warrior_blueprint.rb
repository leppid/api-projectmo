class WarriorBlueprint < Blueprinter::Base
  fields :id

  field :name do |obj|
    obj.try(:login)
  end

  field :model do
    'playerbattle'
  end

  field :models do |obj|
    [obj.try(:head_armor)&.model, obj.try(:body_armor)&.model, obj.try(:legs_armor)&.model, obj.try(:primary_weapon)&.model, obj.try(:secondary_weapon)&.model].compact
  end

  field :health do
    100
  end

  field :armor do
    10
  end

  field :min_damage do
    10
  end

  field :max_damage do
    20
  end

  field :crit_multiplier do
    100
  end

  field :crit_chance do
    10
  end

  field :bot do
    false
  end
end
