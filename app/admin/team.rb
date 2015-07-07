ActiveAdmin.register Team do
  config.clear_action_items!

  filter :name_eq, label: "Name"
  filter :region, as: :select, collection: Team.regions.sort
  filter :country, as: :select, collection: ActionView::Helpers::FormOptionsHelper::COUNTRIES
  filter :division, as: :select, collection: Team.divisions.sort
  filter :year_eq, label: "Year"
  filter :category, as: :select, collection: Category.order(:name)
  filter :event, as: :select, collection: Event.order(:name)
  filter :description_cont, label: "Description"
  filter :issemifinalist
  filter :isfinalist
  filter :iswinner
  filter :submitted

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
    column (:rubrics_average){|t| t.avg_score}
    column (:quarterfinal_average){|t| t.avg_quarterfinal_score}
    column (:semifinal_average){|t| t.avg_semifinal_score}
    column (:final_average){|t| t.avg_final_score}

    column :issemifinalist
    column :isfinalist
    column :iswinner

    actions
  end

  csv do
    column :name
    column :region
    column :city do |t|
      members_by_city = t.members(true).student.group_by(&:home_city)
      if members_by_city.size > 0
        members_by_city.values.max_by(&:size).first.home_city
      end
    end

    column :state do |t|
      members_by_state = t.members(true).student.group_by(&:home_state)
      if members_by_state.size > 0
        members_by_state.values.max_by(&:size).first.home_state
      end
    end

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
    column (:rubrics_average){|t| t.avg_score}
    column (:quarterfinal_average){|t| t.avg_quarterfinal_score}
    column (:semifinal_average){|t| t.avg_semifinal_score}
    column (:final_average){|t| t.avg_final_score}

    column :issemifinalist
    column :isfinalist
    column :iswinner
  end

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
