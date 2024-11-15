ActiveAdmin.register PlayersWeapons, as: "Player Weapons" do
  menu priority: 6

  permit_params :player_id, :weapon_id

  filter :id_eq
  filter :player_id_eq
  filter :weapon_id_eq

  index do
    selectable_column
    id_column
    column :player_id do |obj|
      link_to "#{obj.player.login}", admin_player_path(obj.player_id)
    end
    column :weapon_id do |obj|
      link_to "#{obj.weapon.name} [#{obj.weapon.type}]", admin_weapon_path(obj.weapon_id)
    end
    actions
  end

  show do
    attributes_table_for(resource) do
      row :player_id do |obj|
        link_to "#{obj.player.login}", admin_player_path(obj.player_id)
      end
      row :weapon_id do |obj|
        link_to "#{obj.weapon.name} [#{obj.weapon.type}]", admin_weapon_path(obj.weapon_id)
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :player_id, as: :select, collection: Player.all.map { |p| ["#{p.login} [#{p.id}]", p.id] }
      f.input :weapon_id, as: :select, collection: Weapon::Base.all.map { |w| ["#{w.name} [#{w.type} #{w.id}]", w.id] }
    end
    f.actions
  end
end
