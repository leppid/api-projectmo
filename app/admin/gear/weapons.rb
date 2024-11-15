ActiveAdmin.register Weapon::Base, as: "Weapons" do
  menu priority: 3

  permit_params :name, :type

  filter :id
  filter :name
  filter :type, as: :select, collection: Weapon::Base::TYPES

  index do
    selectable_column
    id_column
    column :name
    column :type
    actions
  end

  show do
    attributes_table_for(resource) do
      row :name
      row :type
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :type, as: :select, collection: Weapon::Base::TYPES, default: Weapon::Base::TYPES[0]
    end
    f.actions
  end
end
