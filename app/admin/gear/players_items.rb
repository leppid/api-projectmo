ActiveAdmin.register PlayersItems, as: "Player Items" do
  menu priority: 7

  permit_params :player_id, :item_id

  filter :id_eq
  filter :player_id_eq
  filter :item_id_eq

  index do
    selectable_column
    id_column
    column :player_id do |obj|
      link_to "#{obj.player.login}", admin_player_path(obj.player_id)
    end
    column :item_id do |obj|
      link_to "#{obj.item.name} [#{obj.item.type}]", admin_item_path(obj.item_id)
    end
    actions
  end

  show do
    attributes_table_for(resource) do
      row :player_id do |obj|
        link_to "#{obj.player.login}", admin_player_path(obj.player_id)
      end
      row :item_id do |obj|
        link_to "#{obj.item.name} [#{obj.item.type}]", admin_item_path(obj.item_id)
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :player_id, as: :select, collection: Player.all.map { |p| ["#{p.login} [#{p.id}]", p.id] }
      f.input :item_id, as: :select, collection: Item::Base.all.map { |i| ["#{i.name} [#{i.type} #{i.id}]", i.id] }
    end
    f.actions
  end
end
