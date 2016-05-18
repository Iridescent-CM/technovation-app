ActiveAdmin.register TeamRequest do
  menu priority: 20

  index do
    selectable_column
    column :team
    column :user
    column "Email" do |team_request|
      team_request.user_email
    end
    column "Role" do |team_request|
      team_request.user_role
    end
    column :user_request
    column :approved
    actions
  end

end
