ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
  #   div class: "blank_slate_container", id: "dashboard_default_message" do
  #     span class: "blank_slate" do
  #       span I18n.t("active_admin.dashboard_welcome.welcome")
  #       small I18n.t("active_admin.dashboard_welcome.call_to_action")
  #     end
  #   end
    columns do
      column do
        panel "Recent Annoucements" do
          ul do
            Annoucement.last(3).map do |post|
              li link_to(post.title, admin_annoucement_path(post))
            end
          end
        end
      end
      column do
        panel "Statistics" do
            ul do
                li "Current Users: #{User.count}" do
                    ul do
                        li "Students: #{User.student.count}"
                        li "Mentors: #{User.mentor.count}"
                    end
                end
                li "Current Teams: #{Team.count}"
            end
        end
      end
    end
end

end
