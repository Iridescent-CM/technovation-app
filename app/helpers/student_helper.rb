module StudentHelper
  def student_navigation
    StudentNavigationView.new(
      StudentAccount.find_with_token(cookies.fetch(:auth_token) { "" })
    )
  end

  class StudentNavigationView < Struct.new(:student)
    include Rails.application.routes.url_helpers
    include ActionView::Helpers

    def team_link
      link = if student.is_on_team?
               link_to(I18n.translate("views.student.navigation.your_team"),
                       student_team_path(student.team))
             else
               link_to(I18n.translate("views.student.navigation.create_a_team"),
                       new_student_team_path)
             end

      content_tag :li, link, class: "nav-link"
    end
  end
end
