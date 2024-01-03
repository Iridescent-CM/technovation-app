module DataAnalyses
  class ReturningMentorsDataAnalysis < DataAnalysis
    def init_data
      @mentors = if user.is_admin?
        Account.current.left_outer_joins(:mentor_profile)
          .where("mentor_profiles.id IS NOT NULL")
      else
        Account.current.left_outer_joins(:mentor_profile)
          .where("mentor_profiles.id IS NOT NULL")
          .in_region(user)
      end

      @new_mentors = @mentors.where("array_length(accounts.seasons, 1) = 1")
      @returning_mentors = @mentors.where("array_length(accounts.seasons, 1) > 1")
    end

    def totals
      {
        mentors: number_with_delimiter(@mentors.count)
      }
    end

    def labels
      [
        "Returning mentors – #{show_percentage(@returning_mentors, @mentors)}",
        "New mentors – #{show_percentage(@new_mentors, @mentors)}"
      ]
    end

    def data
      [
        @returning_mentors.count,
        @new_mentors.count
      ]
    end
  end
end
