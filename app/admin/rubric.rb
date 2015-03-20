ActiveAdmin.register Rubric do


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

  index do
    selectable_column
    column (:judge_email){|r| User.find(r.user_id).email}

    column (:team_name){|r| Team.find(r.team_id).name}
    column (:region){|r| Team.find(r.team_id).region}

    # column :region, sortable: :region do |r|
    #     Team.find(r.team_id).region
    #   end

    column (:division){|r| Team.find(r.team_id).division}

    column (:event){|r| 
      team = Team.find(r.team_id)
      unless team.event_id.nil?
        Event.find(team.event_id).name
      end
    }

    column (:score){|r| r.score}
    column :identify_problem
    column :address_problem
    column :functional
    column :external_resources
    column :match_features
    column :interface
    column :description
    column :market
    column :competition
    column :revenue
    column :branding
    column :pitch
    column :launched

  end
end
