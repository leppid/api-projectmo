ActiveAdmin.register Player::Weapon::Base, as: "Player Weapons" do
  menu priority: 6

  permit_params :player_id, :game_weapon_id

  filter :id_eq
  filter :player_id_eq
  filter :game_weapon_id_eq
  filter :type, as: :select, collection: Player::Weapon::Base::TYPES

  member_action :equip, method: %i[put] do
    resource.equip
    if params[:index] == 'true'
      redirect_to admin_player_weapons_path, notice: 'Equiped!'
    else
      redirect_to admin_player_weapon_path(resource.id), notice: 'Equiped!'
    end
  end

  member_action :unequip, method: %i[put] do
    resource.unequip
    if params[:index] == 'true'
      redirect_to admin_player_weapons_path, notice: 'Unequiped!'
    else
      redirect_to admin_player_weapon_path(resource.id), notice: 'Unequiped!'
    end
  end

  action_item :equip, only: :show, priority: 0, if: proc { !resource.equiped? } do
    link_to "Equip", equip_admin_player_weapon_path(resource), method: :put 
  end

  action_item :unequip, only: :show, priority: 0, if: proc { resource.equiped? } do 
    link_to "Unequip", unequip_admin_player_weapon_path(resource), method: :put
  end

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
    column :game_weapon_id do |obj|
      link_to "#{obj.game_weapon.name} [#{obj.game_weapon.type}]", admin_game_weapon_path(obj.game_weapon_id)
    end
    column :type
    column :equiped?
    column :actions do |obj|
      links = []
      links << link_to('Equip', equip_admin_player_weapon_path(obj, index: true), method: :put) if !obj.equiped?
      links << link_to('Unequip', unequip_admin_player_weapon_path(obj, index: true), method: :put) if obj.equiped?
      links << link_to('Show', admin_player_weapon_path(obj))
      links << link_to('Edit', edit_admin_player_weapon_path(obj))
      links << link_to('Delete', admin_player_weapon_path(obj), method: :delete, confirm: 'Are you sure?')
      links.join(' ').html_safe
    end
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
      row :game_weapon_id do |obj|
        link_to "#{obj.game_weapon.name} [#{obj.game_weapon.type}]", admin_game_weapon_path(obj.game_weapon_id)
      end
      row :type
      row :equiped?
    end
  end

  form do |f|
    f.inputs do
      f.input :player_id, as: :select, collection: Player.all.map { |p| ["#{p.login} [#{p.id}]", p.id] }
      f.input :game_weapon_id, as: :select, collection: Game::Weapon::Base.all.map { |w| ["#{w.name} [#{w.type} #{w.id}]", w.id] }
    end
    f.actions
  end
end
