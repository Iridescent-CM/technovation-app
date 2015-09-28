ActiveAdmin.register Region do
  filter :region_name_eq, label: "Name"
  filter :division, as: :select, collection: Region.divisions.sort

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Team Details" do
      f.input :region_name
      f.input :division, as: :select, collection: Region.divisions.keys
    end
    f.actions
  end
end