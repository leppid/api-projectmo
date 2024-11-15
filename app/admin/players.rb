ActiveAdmin.register Player, as: "Players" do
  menu priority: 1

  permit_params :login, :password, :location, :position

  index do
    selectable_column
    id_column
    column :display_name
    column :login
    column :location
    column :position
    actions
  end

  show do
    panel  "Info" do
      attributes_table_for(resource) do
        row :display_name
        row :login
        row :location
        row :position
      end
    end

    panel "Equipment" do
      attributes_table_for(resource) do
        row :head do |obj|
          model = obj.head
          if (model)
            link_to "#{model.name} [#{model.type} #{model.id}]", admin_armor_path(model.id)
          else
            "Empty"
          end
        end
        row :body do |obj|
          model = obj.body
          if (model)
            link_to "#{model.name} [#{model.type} #{model.id}]", admin_armor_path(model.id)
          else
            "Empty"
          end
        end
        row :legs do |obj|
          model = obj.legs
          if (model)
            link_to "#{model.name} [#{model.type} #{model.id}]", admin_armor_path(model.id)
          else
            "Empty"
          end
        end
        row :primary do |obj|
          model = obj.primary
          if (model)
            link_to "#{model.name} [#{model.type} #{model.id}]", admin_weapon_path(model.id)
          else
            "Empty"
          end
        end
        row :secondary do |obj|
          model = obj.secondary
          if (model)
            link_to "#{model.name} [#{model.type} #{model.id}]", admin_weapon_path(model.id)
          else
            "Empty"
          end
        end
      end
    end

    panel "Gear" do
      attributes_table_for(resource) do
        row :armors do |obj|
          link_to "View (#{obj.armors.count})", admin_player_armors_path(q: { player_id_eq: obj.id })
        end
        row :weapons do |obj|
          link_to "View (#{obj.weapons.count})", admin_player_weapons_path(q: { player_id_eq: obj.id })
        end
        row :items do |obj|
          link_to "View (#{obj.items.count})", admin_player_items_path(q: { player_id_eq: obj.id })
        end
      end
    end
  end

  filter :id
  filter :login
  filter :location

  form do |f|
    f.inputs do
      f.input :login
      f.input :password
      f.input :location
      f.input :position
    end
    f.actions
  end
end
