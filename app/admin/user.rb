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
      row :email
      row :role
      row :first_name
      row :last_name
      row :birthday

      row :home_country
      row :consent_signed_at

      row :can_judge
      row :num_judged
      row :judging_event
      row :conflict_region
      row :judging_region
    end
  end

  index do
    selectable_column
    column :email
    column :role
    column :first_name
    column :last_name
    column :birthday
    column :home_country
    column :consent_signed_at

    column (:can_judge){|u| u.judge? or u.judging}
    column (:num_judged){|u| Rubric.where(user_id: u.id).length}
    column (:judging_event){|u| unless u.event_id.nil? 
                                  link_to Event.find(u.event_id).name, admin_event_path(u.event_id)
                                end}

    column (:conflict_region){|u| u.conflict_region.nil? ? nil : Team.regions.keys[u.conflict_region]}
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
      f.input :conflict_region, as: :select, collection: Team.regions.keys
      f.input :judging_region, as: :select, collection: Team.regions.keys
    end


    f.actions
  end
end
