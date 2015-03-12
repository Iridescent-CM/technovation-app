ActiveAdmin.register Event do


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

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Event Details" do
      f.input :name
      f.input :location
      f.input :whentooccur
      f.input :description
      f.input :organizer
      f.input :region, as: :select, collection: Team.regions.keys
    end
    f.actions
  end


end
