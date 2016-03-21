ActiveAdmin.register Event do
  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Event Details" do
      f.input :name
      f.input :is_virtual, label: "Is it a virtual event?"
      f.input :location
      f.input :whentooccur
      f.input :description
      f.input :organizer
      f.input :region
    end
    f.actions
  end
end
