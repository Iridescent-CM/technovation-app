ActiveAdmin.register Team do
  config.clear_action_items!

  filter :name_eq, label: "Name"
  filter :region
  filter :country, as: :select, collection: ActionView::Helpers::FormOptionsHelper::COUNTRIES
  filter :division, as: :select, collection: Team.divisions.sort
  filter :year_eq, label: "Year"
  filter :category, as: :select, collection: Category.order(:name)
  filter :event, as: :select, collection: Event.order(:name)
  filter :description_cont, label: "Description"
  filter :is_semi_finalist
  filter :is_finalist
  filter :is_winner
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
    column :state
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

    column :is_semi_finalist
    column :is_finalist
    column :is_winner

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

    column :state

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

    column :is_semi_finalist
    column :is_finalist
    column :is_winner
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Team Details" do
      f.input :name
      f.input :about
      f.input :year
      f.input :avatar, as: :file, required: false
      f.input :region
      f.input :division, as: :select, collection: Team.divisions.keys
      f.input :country, as: :country

#      f.input :event, as: :select, collection: Event.all

      f.input :is_semi_finalist
      f.input :is_finalist
      f.input :is_winner

      f.input :event_id, as: :select, collection: Event.all

    end
    f.actions
  end
end
