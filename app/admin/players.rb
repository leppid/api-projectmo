ActiveAdmin.register Player do
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
