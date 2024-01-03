module DataAnalyses
  class ReturningStudentsDataAnalysis < DataAnalysis
    def init_data
      @students = if user.is_admin?
        StudentProfile.current
      else
        StudentProfile.current.in_region(user)
      end

      @new_students = @students.where("array_length(accounts.seasons, 1) = 1")
      @returning_students = @students.where("array_length(accounts.seasons, 1) > 1")
    end

    def totals
      {
        students: number_with_delimiter(@students.count)
      }
    end

    def labels
      [
        "Returning students – #{show_percentage(@returning_students, @students)}",
        "New students – #{show_percentage(@new_students, @students)}"
      ]
    end

    def data
      [
        @returning_students.count,
        @new_students.count
      ]
    end
  end
end
