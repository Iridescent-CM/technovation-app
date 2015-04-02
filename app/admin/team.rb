ActiveAdmin.register Team do
  config.clear_action_items!

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  index do
    selectable_column
    column :name
    column :region
    column :country do |team|
      ISO3166::Country[team.country]
    end
    column :division
    column :year

    column :event_id do |t|
      unless t.event_id.nil?
        link_to Event.find(t.event_id).name, admin_event_path(t.event_id)
      end
    end

    column (:rubrics_count){|t| t.rubrics.length}
    column (:rubrics_average){|t| 
      scores = t.rubrics.map{|r| r.score}
      scores.inject(:+).to_f / scores.size
      }

    column :issemifinalist
    column :isfinalist
    column :iswinner

    actions
  end

  filter :name
  filter :region, as: :select, collection: Team.regions
  filter :country, as: :select, collection: ActionView::Helpers::FormOptionsHelper::COUNTRIES
  filter :division, as: :select, collection: Team.divisions
  filter :year
  preserve_default_filters!

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Team Details" do
      f.input :name
      f.input :about
      f.input :year
      f.input :avatar, as: :file, required: false
      f.input :region, as: :select, collection: Team.regions.keys
      f.input :division, as: :select, collection: Team.divisions.keys
      f.input :country, as: :country

#      f.input :event, as: :select, collection: Event.all

      f.input :issemifinalist
      f.input :isfinalist
      f.input :iswinner

      f.input :event_id, as: :select, collection: Event.all

    end
    f.actions
  end
end
