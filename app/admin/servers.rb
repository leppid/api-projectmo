ActiveAdmin.register Server, as: "Server" do
  menu priority: 0
  
  permit_params :open

  index do
    selectable_column
    id_column
    column :open
    actions
  end

  show do
    attributes_table_for(resource) do
      row :open
    end 
  end

  form do |f|
    f.inputs do
      f.input :open
    end
    f.actions
  end

end
