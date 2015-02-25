ActiveAdmin.register TeamRequest do
  menu priority: 20

  index do
    selectable_column
    column :team
    column :user
    column "Email" do |teamrequest|
      teamrequest.user.email
    end
    column :user_request
    column :approved
    actions
  end

end
