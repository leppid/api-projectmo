ActiveAdmin.register Game::Item::Base, as: "Game Items" do
  menu priority: 7

  permit_params :player_id, :draft_item_id

  filter :id_eq
  filter :player_id_eq
  filter :draft_item_id_eq
  filter :type, as: :select, collection: Game::Item::Base::TYPES

  index do
    selectable_column
    id_column
    column :player_id do |obj|
      if obj.owner
        link_to "#{obj.owner.login}", admin_player_path(obj.owner.id)
      else
        "Empty"
      end
    end
    column :draft_item_id do |obj|
      link_to "#{obj.draft_item.name} [#{obj.draft_item.type}]", admin_draft_item_path(obj.draft_item_id)
    end
    column :type
    actions
  end

  show do
    attributes_table_for(resource) do
      row :player_id do |obj|
        if obj.owner
          link_to "#{obj.owner.login}", admin_player_path(obj.owner.id)
        else
          "Empty"
        end
      end
      row :draft_item_id do |obj|
        link_to "#{obj.draft_item.name} [#{obj.draft_item.type}]", admin_draft_item_path(obj.draft_item_id)
      end
      row :type
    end
  end

  form do |f|
    f.inputs do
      f.input :player_id, as: :select, collection: Player.all.map { |p| ["#{p.login} [#{p.id}]", p.id] }
      f.input :draft_item_id, as: :select, collection: Draft::Item::Base.all.map { |i| ["#{i.name} [#{i.type} #{i.id}]", i.id] }
    end
    f.actions
  end
end
