ActiveAdmin.register Player do
  permit_params :login, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :login
    actions
  end

  filter :id
  filter :login

  form do |f|
    f.inputs do
      f.input :login
      f.input :password
    end
    f.actions
  end
end
