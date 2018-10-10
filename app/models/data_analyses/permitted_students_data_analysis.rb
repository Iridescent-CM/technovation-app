
module DataAnalyses
  class PermittedStudentsDataAnalysis < DataAnalysis
    def init_data
      if user.is_admin?
        @students = StudentProfile.current
      else
        @students = StudentProfile.current.in_region(user)
      end

      @permitted_students = @students.joins(:signed_parental_consent)
      @unpermitted_students = @students.joins(:pending_parental_consent)
    end

    def totals
      {
        students: number_with_delimiter(@students.count),
      }
    end

    def labels
      [
        "With parental permission – #{show_percentage(@permitted_students, @students)}",
        "Without parental permission – #{show_percentage(@unpermitted_students, @students)}",
      ]
    end

    def data
      [
        @permitted_students.count,
        @unpermitted_students.count,
      ]
    end

    def urls
      [
        url_helper.public_send("#{user.scope_name}_participants_path",
          accounts_grid: {
            scope_names: ["student"],
            parental_consent: "parental_consented",
          }
        ),

        url_helper.public_send("#{user.scope_name}_participants_path",
          accounts_grid: {
            scope_names: ["student"],
            parental_consent: "not_parental_consented",
          }
        ),
      ]
    end
  end
end