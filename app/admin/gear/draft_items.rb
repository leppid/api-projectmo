ActiveAdmin.register Draft::Item::Base, as: "Draft Items" do
  menu priority: 4

  permit_params :name, :type

  filter :id
  filter :name
  filter :type, as: :select, collection: Draft::Item::Base::TYPES

  index do
    selectable_column
    id_column
    column :name
    column :type
    column :count_exists do |obj|
      link_to "#{Game::Item::Base.where(draft_item_id: obj.id).count} units", admin_game_items_path(q: { draft_item_id_eq: obj.id })
    end
    actions
  end

  show do
    attributes_table_for(resource) do
      row :name
      row :type
      row :count_exists do |obj|
        link_to "#{Game::Item::Base.where(draft_item_id: obj.id).count} units", admin_game_items_path(q: { draft_item_id_eq: obj.id })
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :type, as: :select, collection: Draft::Item::Base::TYPES, include_blank: false
    end
    f.actions
  end
end
