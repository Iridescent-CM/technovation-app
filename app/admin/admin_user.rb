ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :role, :country, :state

  controller do

    def update
      if params[:admin_user][:password].blank?
        params[:admin_user].delete("password")
        params[:admin_user].delete("password_confirmation")
      end
      super
    end

  end

  index do
    selectable_column
    id_column
    column :email
    column :role
    column :country
    column :state
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :role, as: :select, collection: AdminUser.roles.sort
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :role, as: :select, collection: AdminUser.roles.keys
      f.input :country, as: :select, collection: ActionView::Helpers::FormOptionsHelper::COUNTRIES
      f.input :state, as: :select, collection: us_states
    end
    f.actions
  end

end