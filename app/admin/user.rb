ActiveAdmin.register User do
  filter :teams_id_not_null, label: "Is On Team", as: :boolean
  filter :is_registered, label: "Registered for Season"
  filter :teams_name_cont, label: "Team"
  filter :event, collection: Event.order(:name)
  filter :email_eq, label: "Email"
  filter :role, as: :select, collection: User.roles.sort
  filter :school_cont, label: "School"
  filter :first_name_cont, label: "First Name"
  filter :last_name_cont, label: "Last Name"
  filter :home_city_cont, label: "Home City"
  filter :home_state_cont, label: "Home State"
  filter :postal_code_cont, label: "Postal Code"
  filter :home_country_cont, label: "Home Country"
  filter :birthday
  filter :parent_first_name_cont, label: "Parent First Name"
  filter :parent_last_name_cont, label: "Parent Last Name"
  filter :parent_email_equal, label: "Parent Email"
  filter :is_survey_done
  filter :judging
  filter :conflict_region
  filter :judging_region
  filter :semifinals_judge
  filter :finals_judge
  filter :confirmed_at_not_null, as: :boolean, label: "Confirmation Signed"
  filter :consent_signed_at_not_null, as: :boolean, label: "Consent Signed"
  filter :bg_check_submitted_not_null, as: :boolean, label: "Background Check Submitted"

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end

    def update
      if params[:user][:password].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end

      super
    end

    def scoped_collection
      super.includes :event, { team_requests: :team }, :teams, :judging_region, :conflict_region, :rubrics
    end
  end

  show do
    attributes_table do
      row :id
      row :email
      row :role
      row :first_name
      row :last_name
      row (:is_registered) { |r| r.is_registered ? 'Yes' : 'No' }
      row (:birthday) { |u| u.birthday.strftime('%B %e, %Y') if authorized? :update, u }

      row :home_city
      row :home_state
      row :home_country
      row :consent_signed_at

      row (:teams) { |u| u.teams.map { |t| link_to(t.name, admin_team_path(t)) }.join(', ').html_safe }
      row :can_judge?
      row (:num_judged) { |u| u.rubrics.length }
      row :judging_event
      row (:conflict_regions) { |u| u.conflict_regions.map(&:name).join(', ') }
      row :judging_region
    end
  end

  csv do
    column :id
    column :email
    column :role
    column :first_name
    column :last_name
    column (:is_registered) { |r| r.is_registered ? 'Yes' : 'No' }
    column (:disabled) { |u| u.disabled ? 'Yes' : 'No' }
    column (:birthday) { |u| u.birthday.strftime('%B %e, %Y') if authorized? :update, u }
    column :home_city
    column :home_state
    column :home_country
    column :school
    column :consent_signed_at

    column (:teams) { |u| u.teams.map(&:name).join(', ') }
    column :can_judge?
    column (:num_judged) { |u| u.rubrics.length }
    column (:judging_event) { |u| u.event_name }

    column (:conflict_regions) { |u| u.conflict_regions.map(&:name).join(', ') }
    column (:judging_region) { |u| u.judging_region_name }
    column ('Connect With Other Mentors') { |u| u.connect_with_other ? 'Yes' : 'No' }
  end

  index do
    selectable_column
    column :id
    column :email
    column :role
    column :first_name
    column :last_name
    column (:is_registered) { |r| r.is_registered ? 'Yes' : 'No' }
    column (:birthday) { |u| u.birthday.strftime('%B %e, %Y') if authorized? :update, u }
    column :home_city
    column :home_state
    column :home_country
    column :consent_signed_at

    column (:teams) { |u| u.teams.map { |t| link_to(t.name, admin_team_path(t)) }.join(', ').html_safe }
    column :can_judge?
    column (:num_judged) { |u| u.rubrics.length }
    column (:judging_event) { |u| link_to u.event_name, admin_event_path(u.event) }

    column :judging_region

    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs "Password reset" do
      f.input :password
      f.input :password_confirmation
    end

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
      f.input :conflict_region
      f.input :judging_region
      f.input :event_id, as: :select, collection: Event.all
      f.input :semifinals_judge
      f.input :finals_judge
    end

    f.actions
  end
end
