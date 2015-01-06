ActiveAdmin.register User do

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
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
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs "Account Details" do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :birthday
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
