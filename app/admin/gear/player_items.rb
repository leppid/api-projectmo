ActiveAdmin.register Player::Item::Base, as: "Player Items" do
  menu priority: 7

  permit_params :player_id, :game_item_id

  filter :id_eq
  filter :player_id_eq
  filter :game_item_id_eq
  filter :type, as: :select, collection: Player::Item::Base::TYPES

  index do
    selectable_column
    id_column
    column :player_id do |obj|
      if obj.player_id
        link_to "#{obj.player.login}", admin_player_path(obj.player_id)
      else
        "Empty"
      end
    end
    column :game_item_id do |obj|
      link_to "#{obj.game_item.name} [#{obj.game_item.type}]", admin_game_item_path(obj.game_item_id)
    end
    column :type
    actions
  end

  show do
    attributes_table_for(resource) do
      row :player_id do |obj|
        if obj.player_id
          link_to "#{obj.player.login}", admin_player_path(obj.player_id)
        else
          "Empty"
        end
      end
      row :game_item_id do |obj|
        link_to "#{obj.game_item.name} [#{obj.game_item.type}]", admin_game_item_path(obj.game_item_id)
      end
      row :type
    end
  end

  form do |f|
    f.inputs do
      f.input :player_id, as: :select, collection: Player.all.map { |p| ["#{p.login} [#{p.id}]", p.id] }
      f.input :game_item_id, as: :select, collection: Game::Item::Base.all.map { |i| ["#{i.name} [#{i.type} #{i.id}]", i.id] }
    end
    f.actions
  end
end
