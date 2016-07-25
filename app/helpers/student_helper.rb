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
      content_tag :li, team_link_based_on_membership, class: "nav-link"
    end

    def find_team_link
      unless student.is_on_team?
        content_tag :li, link_to(I18n.translate("views.student.navigation.join_team"),
                                 new_student_team_search_path),
                         class: "nav-link"
      end
    end

    def mentor_search_link
      if student.is_on_team?
        content_tag :li,
                    link_to(
                      I18n.translate('views.student.navigation.find_a_mentor'),
                      student_mentor_search_path
                    ),
                    class: "nav-link"
      end
    end

    private
    def team_link_based_on_membership
      if student.is_on_team?
        link_to(I18n.translate("views.student.navigation.my_team"),
                student_team_path(student.team))
      else
        link_to(I18n.translate("views.student.navigation.create_a_team"),
                new_student_team_path)
      end
    end
  end
end
