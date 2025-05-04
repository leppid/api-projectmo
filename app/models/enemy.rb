class Enemy < ApplicationRecord
  validates :name, :model, :min_damage, :max_damage, :crit_multiplier, :crit_chance, presence: true
end
