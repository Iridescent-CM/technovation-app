ActiveAdmin.register User do

  preserve_default_filters!
  filter :teams_id_not_null, label: "Is On Team", as: :boolean

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  show do
    attributes_table do
      row :id
      row :email
      row :role
      row :first_name
      row :last_name
      row :birthday

      row :home_country
      row :consent_signed_at

      row (:teams){|u| u.teams.nil? ? nil : raw(u.teams.map {|t| raw(link_to(t.name, admin_team_path(t.id)))}.join(', '))}
      row :can_judge
      row (:num_judged){|u| u.rubrics.length}
      row :judging_event
      row (:conflict_regions){|u| u.conflict_regions.nil? ? nil : u.conflict_regions.map {|r| Team.regions.keys[r]}.join(', ')}
      row :judging_region
    end
  end

  csv do
    column :id
    column :email
    column :role
    column :first_name
    column :last_name
    column :birthday
    column :home_country
    column :school
    column :consent_signed_at

    column (:teams){|u| u.teams.nil? ? nil : u.teams.map {|t| t.name}.join(', ')}
    column (:can_judge){|u| u.judge? or u.judging}
    column (:num_judged){|u| u.rubrics.length}
    column (:judging_event){|u| unless u.event_id.nil? 
                                  Event.find(u.event_id).name
                                end}

    column (:conflict_regions){|u| u.conflict_regions.nil? ? nil : u.conflict_regions.map {|r| Team.regions.keys[r]}.join(', ')}
    column (:judging_region){|u| u.judging_region.nil? ? nil : Team.regions.keys[u.judging_region]}
  end

  index do
    selectable_column
    column :id
    column :email
    column :role
    column :first_name
    column :last_name
    column :birthday
    column :home_country
    column :consent_signed_at

    column (:teams){|u| u.teams.nil? ? nil : raw(u.teams.map {|t| raw(link_to(t.name, admin_team_path(t.id)))}.join(', '))}
    column (:can_judge){|u| u.judge? or u.judging}
    column (:num_judged){|u| u.rubrics.length}
    column (:judging_event){|u| unless u.event_id.nil? 
                                  link_to Event.find(u.event_id).name, admin_event_path(u.event_id)
                                end}

    column (:conflict_regions){|u| u.conflict_regions.nil? ? nil : u.conflict_regions.map {|r| Team.regions.keys[r]}.join(', ')}
    column (:judging_region){|u| u.judging_region.nil? ? nil : Team.regions.keys[u.judging_region]}

    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs "Account Details" do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :birthday, start_year: 1930, end_year: 2015
      f.input :role, as: :select, collection: User.roles.keys
    end

    f.inputs "Consent Form" do
      f.input :consent_signed_at
    end

    f.inputs "Background Check Info" do
      f.input :bg_check_id, label: 'Checkr.io Id'
      f.input :disabled, hint: "Check to disable the user's account"
    end

    f.inputs "User Location" do
      f.input :home_city
      f.input :home_state
      f.input :home_country
      f.input :postal_code
    end

    f.inputs "User Bio" do
      f.input :about
      f.input :salutation
      f.input :school
      f.input :grade
      f.input :expertise
      f.input :avatar, as: :file, required: false
    end

    f.inputs "Parent / Guardian Information" do
      f.input :parent_first_name
      f.input :parent_last_name
      f.input :parent_phone
      f.input :parent_email
    end

    f.inputs "Judging Information" do
      f.input :conflict_region, as: :select, collection: Team.regions
      f.input :judging_region, as: :select, collection: Team.regions
      #= f.collection_select :event_id, Event.nonconflicting_events(@user.conflict_regions), :id, :name
      f.input :event_id, as: :select, collection: Event.all
      f.input :semifinals_judge
      f.input :finals_judge
    end


    f.actions
  end
end
