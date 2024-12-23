ActiveAdmin.register Game::Weapon::Base, as: "Game Weapons" do
  menu priority: 6

  permit_params :player_id, :draft_weapon_id

  filter :id_eq
  filter :player_id_eq
  filter :draft_weapon_id_eq
  filter :type, as: :select, collection: Game::Weapon::Base::TYPES

  member_action :equip, method: %i[put] do
    resource.equip
    if params[:index] == 'true'
      redirect_to admin_game_weapons_path, notice: 'Equiped!'
    else
      redirect_to admin_game_weapon_path(resource.id), notice: 'Equiped!'
    end
  end

  member_action :unequip, method: %i[put] do
    resource.unequip
    if params[:index] == 'true'
      redirect_to admin_game_weapons_path, notice: 'Unequiped!'
    else
      redirect_to admin_game_weapon_path(resource.id), notice: 'Unequiped!'
    end
  end

  action_item :equip, only: :show, priority: 0, if: proc { !resource.equiped? } do
    link_to "Equip", equip_admin_game_weapon_path(resource), method: :put 
  end

  action_item :unequip, only: :show, priority: 0, if: proc { resource.equiped? } do 
    link_to "Unequip", unequip_admin_game_weapon_path(resource), method: :put
  end

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
    column :draft_weapon_id do |obj|
      link_to "#{obj.draft_weapon.name} [#{obj.draft_weapon.type}]", admin_draft_weapon_path(obj.draft_weapon_id)
    end
    column :type
    column :equiped?
    column :actions do |obj|
      links = []
      links << link_to('Equip', equip_admin_game_weapon_path(obj, index: true), method: :put) if !obj.equiped?
      links << link_to('Unequip', unequip_admin_game_weapon_path(obj, index: true), method: :put) if obj.equiped?
      links << link_to('Edit', edit_admin_game_weapon_path(obj))
      links << link_to('Delete', admin_game_weapon_path(obj), method: :delete, confirm: 'Are you sure?')
      links.join(' ').html_safe
    end
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
      row :draft_weapon_id do |obj|
        link_to "#{obj.draft_weapon.name} [#{obj.draft_weapon.type}]", admin_draft_weapon_path(obj.draft_weapon_id)
      end
      row :type
      row :equiped?
    end
  end

  form do |f|
    f.inputs do
      f.input :player_id, as: :select, collection: Player.all.map { |p| ["#{p.login} [#{p.id}]", p.id] }
      f.input :draft_weapon_id, as: :select, collection: Draft::Weapon::Base.all.map { |w| ["#{w.name} [#{w.type} #{w.id}]", w.id] }
    end
    f.actions
  end
end
