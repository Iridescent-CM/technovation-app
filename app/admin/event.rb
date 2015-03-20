ActiveAdmin.register Event do
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
