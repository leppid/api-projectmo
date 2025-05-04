class EnemyBlueprint < Blueprinter::Base
  fields :id, :name, :model, :min_damage, :max_damage, :crit_multiplier, :crit_chance

  field :armor do
    10
  end

  field :bot do
    true
  end
end
