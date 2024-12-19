ActiveAdmin.register Game::Armor::Base, as: 'Game Armors' do
  menu priority: 2

  permit_params :name, :type

  filter :id
  filter :name
  filter :type, as: :select, collection: Game::Armor::Base::TYPES

  index do
    selectable_column
    id_column
    column :name
    column :type
    column :count_exists do |obj|
      link_to "#{Player::Armor::Base.where(game_armor_id: obj.id).count} units", admin_player_armors_path(q: { game_armor_id_eq: obj.id })
    end
    actions
  end

  show do
    attributes_table_for(resource) do
      row :name
      row :type
      row :count_exists do |obj|
        link_to "#{Player::Armor::Base.where(game_armor_id: obj.id).count} units", admin_player_armors_path(q: { game_armor_id_eq: obj.id })
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :type, as: :select, collection: Game::Armor::Base::TYPES, default: Game::Armor::Base::TYPES[0]
    end
    f.actions
  end
end
