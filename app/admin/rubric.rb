ActiveAdmin.register Rubric do
  index do
    selectable_column
    column (:judge_email){|r| User.find(r.user_id).email}

    column (:team_name){|r| Team.find(r.team_id).name}
    column (:region){|r| r.team.region.name}

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

    column :stage
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
