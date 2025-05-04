ActiveAdmin.register Game::Armor::Base, as: "Game Armors" do
  menu priority: 6

  permit_params :player_id, :draft_armor_id

  filter :id_eq
  filter :player_id_eq
  filter :draft_armor_id_eq
  filter :type, as: :select, collection: Game::Armor::Base::TYPES

  member_action :equip, method: %i[put] do
    resource.equip
    if params[:index] == 'true'
      redirect_to admin_game_armors_path, notice: 'Equiped!'
    else 
      redirect_to admin_game_armor_path(resource.id), notice: 'Equiped!'
    end
  end

  member_action :unequip, method: %i[put] do
    resource.unequip
    if params[:index] == 'true'
      redirect_to admin_game_armors_path, notice: 'Unequiped!'
    else 
      redirect_to admin_game_armor_path(resource.id), notice: 'Unequiped!'
    end
  end

  action_item :equip, only: :show, priority: 0, if: proc { !resource.equiped? } do
    link_to "Equip", equip_admin_game_armor_path(resource, index: false), method: :put 
  end

  action_item :unequip, only: :show, priority: 0, if: proc { resource.equiped? } do 
    link_to "Unequip", unequip_admin_game_armor_path(resource, index: false), method: :put
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
    column :draft_armor_id do |obj|
      link_to "#{obj.draft_armor.name} [#{obj.draft_armor.type}]", admin_draft_armor_path(obj.draft_armor_id)
    end
    column :type
    column :equiped?
    column :index
    column :created_at
    column :updated_at
    column :actions do |obj|
      links = []
      links << link_to('Equip', equip_admin_game_armor_path(obj, index: true), method: :put) if !obj.equiped?
      links << link_to('Unequip', unequip_admin_game_armor_path(obj, index: true), method: :put) if obj.equiped?
      links << link_to('Edit', edit_admin_game_armor_path(obj))
      links << link_to('Delete', admin_game_armor_path(obj), method: :delete, confirm: 'Are you sure?')
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
      row :draft_armor_id do |obj|
        link_to "#{obj.draft_armor.name} [#{obj.draft_armor.type}]", admin_draft_armor_path(obj.draft_armor_id)
      end
      row :type
      row :equiped?
      row :index
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :player_id, as: :select, collection: Player.all.map { |p| ["#{p.login} [#{p.id}]", p.id] }
      f.input :draft_armor_id, as: :select, collection: Draft::Armor::Base.all.map { |a| ["#{a.name} [#{a.type} #{a.id}]", a.id] }
    end
    f.actions
  end
end
