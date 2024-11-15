ActiveAdmin.register Item::Base, as: "Items" do
  menu priority: 4

  permit_params :name, :type

  filter :id
  filter :name
  filter :type, as: :select, collection: Item::Base::TYPES

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
      f.input :type, as: :select, collection: Item::Base::TYPES, default: Item::Base::TYPES[0]
    end
    f.actions
  end
end
