ActiveAdmin.register Enemy, as: "Enemies" do
  menu priority: 2

  permit_params :name, :model, :min_damage, :max_damage, :crit_multiplier, :crit_chance

  index do
    selectable_column
    id_column
    column :name
    column :model
    column :min_damage
    column :max_damage
    column :crit_multiplier
    column :crit_chance
    column :created_at
    column :updated_at
    actions
  end

  show do
    panel  "Info" do
      attributes_table_for(resource) do
        row :name
        row :model
        row :min_damage
        row :max_damage
        row :crit_multiplier
        row :crit_chance
        row :created_at
        row :updated_at
      end
    end
  end

  filter :id
  filter :name
  filter :model

  form do |f|
    f.inputs do
      f.input :name
      f.input :model
      f.input :min_damage
      f.input :max_damage
      f.input :crit_multiplier
      f.input :crit_chance
    end
    f.actions
  end
end
