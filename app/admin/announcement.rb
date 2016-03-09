ActiveAdmin.register Announcement do

  filter :role, as: :select, collection: Announcement.roles.sort

  form do |f|
    f.inputs do
      f.input :title
      f.input :post
      f.input :published
      f.input :role, as: :select, collection: Announcement.roles.keys
    end
    f.actions
  end


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end


end
