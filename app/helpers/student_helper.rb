module StudentHelper
  def student_navigation
    StudentNavigationView.new(
      StudentAccount.find_with_token(cookies.fetch(:auth_token) { "" })
    )
  end

  class StudentNavigationView < Struct.new(:student)
    include Rails.application.routes.url_helpers
    include ActionView::Helpers

    def create_team_link
      unless student.is_on_team?
        link = link_to(I18n.translate("views.student.navigation.create_a_team"),
                      new_student_team_path)
        content_tag :li, link, class: "nav-link"
      end
    end
  end
end
