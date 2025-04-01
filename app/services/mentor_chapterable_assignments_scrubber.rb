class MentorChapterableAssignmentsScrubber
  def initialize(mentor_profile:)
    @mentor_profile = mentor_profile
  end

  def call
    chapterable_assignments_to_be_removed_from_mentor.each do |assignment|
      assignment.delete
    end
  end

  private

  attr_accessor :mentor_profile

  def chapterable_assignments_to_be_removed_from_mentor
    mentor_chapterable_assignments.uniq.reject do |mentor_chapterable_assignment|
      mentor_team_chapterable_assignments.any? do |mentor_team_chapterable_assignment|
        mentor_chapterable_assignment.chapterable_type == mentor_team_chapterable_assignment.chapterable_type &&
          mentor_chapterable_assignment.chapterable_id == mentor_team_chapterable_assignment.chapterable_id
      end
    end
      .reject(&:blank?)
  end

  def mentor_chapterable_assignments
    mentor_profile.account.current_chapterable_assignments
      .reject(&:primary?)
  end

  def mentor_team_chapterable_assignments
    mentor_profile.teams.current.flat_map do |team|
      team.students.flat_map do |student|
        student.account.current_chapterable_assignment
      end
    end
  end
end
