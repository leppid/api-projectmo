ActiveAdmin.register Draft::Weapon::Base, as: "Draft Weapons" do
  menu priority: 3

  permit_params :name, :type

  filter :id
  filter :name
  filter :type, as: :select, collection: Draft::Weapon::Base::TYPES

  index do
    selectable_column
    id_column
    column :name
    column :type
    column :count_exists do |obj|
      link_to "#{Game::Weapon::Base.where(draft_weapon_id: obj.id).count} units", admin_game_weapons_path(q: { draft_weapon_id_eq: obj.id })
    end
    actions
  end

  show do
    attributes_table_for(resource) do
      row :name
      row :type
      row :count_exists do |obj|
        link_to "#{Game::Weapon::Base.where(draft_weapon_id: obj.id).count} units", admin_game_weapons_path(q: { draft_weapon_id_eq: obj.id })
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :type, as: :select, collection: Draft::Weapon::Base::TYPES, default: Draft::Weapon::Base::TYPES[0]
    end
    f.actions
  end
end
