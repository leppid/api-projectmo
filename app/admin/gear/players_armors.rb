ActiveAdmin.register PlayersArmors, as: "Player Armors" do
  menu priority: 5

  permit_params :player_id, :armor_id

  filter :id_eq
  filter :player_id_eq
  filter :armor_id_eq

  index do
    selectable_column
    id_column
    column :player_id do |obj|
      link_to "#{obj.player.login}", admin_player_path(obj.player_id)
    end
    column :armor_id do |obj|
      link_to "#{obj.armor.name} [#{obj.armor.type}]", admin_armor_path(obj.armor_id)
    end
    actions
  end

  show do
    attributes_table_for(resource) do
      row :player_id do |obj|
        link_to "#{obj.player.login}", admin_player_path(obj.player_id)
      end
      row :armor_id do |obj|
        link_to "#{obj.armor.name} [#{obj.armor.type}]", admin_armor_path(obj.armor_id)
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :player_id, as: :select, collection: Player.all.map { |p| ["#{p.login} [#{p.id}]", p.id] }
      f.input :armor_id, as: :select, collection: Armor::Base.all.map { |a| ["#{a.name} [#{a.type} #{a.id}]", a.id] }
    end
    f.actions
  end
end
