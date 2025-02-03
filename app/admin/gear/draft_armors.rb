ActiveAdmin.register Draft::Armor::Base, as: 'Draft Armors' do
  menu priority: 2

  permit_params :name, :model, :type

  filter :id
  filter :name
  filter :type, as: :select, collection: Draft::Armor::Base::TYPES

  index do
    selectable_column
    id_column
    column :name
    column :model
    column :type
    column :count_exists do |obj|
      link_to "#{Game::Armor::Base.where(draft_armor_id: obj.id).count} units", admin_game_armors_path(q: { draft_armor_id_eq: obj.id })
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table_for(resource) do
      row :name
      row :model
      row :type
      row :count_exists do |obj|
        link_to "#{Game::Armor::Base.where(draft_armor_id: obj.id).count} units", admin_game_armors_path(q: { draft_armor_id_eq: obj.id })
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :model
      f.input :type, as: :select, collection: Draft::Armor::Base::TYPES, include_blank: false
    end
    f.actions
  end
end
