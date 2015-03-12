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
    column :division
    column :year
    # column :rubrics_average
    # column :rubrics_count

    # column (:team_name){|r| Team.find(r.team_id).name}
    # column (:region){|r| Team.find(r.team_id).region}
    column (:count){|t| t.rubrics.length}
    column (:average){|t| 
      scores = t.rubrics.map{|r| r.score}
      scores.inject(:+).to_f / scores.size
      }

    column :event_id do |t|
      unless t.event_id.nil?
        link_to Event.find(t.event_id).name, admin_event_path(t.event_id)
      end
    end

    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Team Details" do
      f.input :name
      f.input :about
      f.input :year
      f.input :avatar, as: :file, required: false
      f.input :region, as: :select, collection: Team.regions.keys
#      f.input :event, as: :select, collection: Event.all
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
