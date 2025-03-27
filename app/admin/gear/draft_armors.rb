ActiveAdmin.register Draft::Armor::Base, as: 'Draft Armors' do
  menu priority: 2

  permit_params :name, :model, :type, :player_id, :disable_head, :disable_body, :disable_arms, :disable_legs

  filter :id
  filter :name
  filter :type, as: :select, collection: Draft::Armor::Base::TYPES

  controller do
    def spawn_for
      return unless params[:player_id]
      resource.spawn_for(params[:player_id])
      redirect_to admin_draft_armor_edit_path(resource.id), notice: 'Generated!'
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :model
    column :type
    column :count_exists do |obj|
      link_to "#{Game::Armor::Base.where(draft_armor_id: obj.id).count} units", admin_game_armors_path(q: { draft_armor_id_eq: obj.id })
    end
    column :test
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table_for(resource) do
      row :name
      row :model
      row :type
      row :count_exists do |obj|
        link_to "#{Game::Armor::Base.where(draft_armor_id: obj.id).count} units", admin_game_armors_path(q: { draft_armor_id_eq: obj.id })
      end
      row :disable_head
      row :disable_body
      row :disable_arms
      row :disable_legs
      row :test
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :model
      f.input :type, as: :select, collection: Draft::Armor::Base::TYPES, include_blank: false
      f.input :player_id, label: "Spawn for", as: :select, collection: Player.all.map { |p| ["#{p.login} [#{p.id}]", p.id] }
      f.input :disable_head
      f.input :disable_body
      f.input :disable_arms
      f.input :disable_legs
      f.input :test
    end
    f.actions
  end
end
