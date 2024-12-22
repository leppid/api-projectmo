ActiveAdmin.register Game::Item::Base, as: "Game Items" do
  menu priority: 7

  permit_params :draft_item_id, :bag_slot_id

  filter :id_eq
  filter :draft_item_id_eq
  filter :type, as: :select, collection: Game::Item::Base::TYPES

  index do
    selectable_column
    id_column
    column :player_id do |obj|
      if obj.player
        link_to "#{obj.player.login}", admin_player_path(obj.player.id)
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
        if obj.player
          link_to "#{obj.player.login}", admin_player_path(obj.player.id)
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
      f.input :draft_item_id, as: :select, collection: Draft::Item::Base.all.map { |i| ["#{i.name} [#{i.type} #{i.id}]", i.id] }
      f.input :bag_slot_id, label: 'Player', as: :select, collection: Player.all.map { |p| next if p.first_empty_bag_slot.blank?; ["#{p.login}", p.first_empty_bag_slot.id] }
    end
    f.actions
  end
end
