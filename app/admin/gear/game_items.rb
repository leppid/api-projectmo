ActiveAdmin.register Game::Item::Base, as: "Game Items" do
  menu priority: 4

  permit_params :name, :type

  filter :id
  filter :name
  filter :type, as: :select, collection: Game::Item::Base::TYPES

  index do
    selectable_column
    id_column
    column :name
    column :type
    column :count_exists do |obj|
      link_to "#{Player::Item::Base.where(game_item_id: obj.id).count} units", admin_player_items_path(q: { game_item_id_eq: obj.id })
    end
    actions
  end

  show do
    attributes_table_for(resource) do
      row :name
      row :type
      row :count_exists do |obj|
        link_to "#{Player::Item::Base.where(game_item_id: obj.id).count} units", admin_player_items_path(q: { game_item_id_eq: obj.id })
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :type, as: :select, collection: Game::Item::Base::TYPES, default: Game::Item::Base::TYPES[0]
    end
    f.actions
  end
end
