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
        panel "Recent Announcements" do
          ul do
            Announcement.last(3).map do |post|
              li link_to(post.title, admin_announcement_path(post))
            end
          end
        end
      end
      column do
        panel "Statistics" do
            ul do
                li "Current Users: #{User.is_registered.count}" do
                    ul do
                        li "Students: #{User.student.is_registered.count}"
                        li "Mentors: #{User.mentor.is_registered.count}"
                        li "Coaches: #{User.coach.is_registered.count}"
                    end
                end
                li "Current Teams: #{Team.current.count}"
            end
        end
        panel "Enum Notes" do
          ul do
            li p "Role Enum: #{User.roles}"
            li p "Expertise Bitmask: #{User::EXPERTISES.each_with_index.map{|k,i| {k[:abbr] => (i+1).to_s(2).rjust(3, '0')}}}"
          end
        end
      end
    end
end

end
