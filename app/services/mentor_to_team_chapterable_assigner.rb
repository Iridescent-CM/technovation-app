class MentorToTeamChapterableAssigner
  def initialize(mentor_profile:, team:)
    @mentor_profile = mentor_profile
    @team = team
  end

  def call
    chapterables_not_assigned_to_mentor.each do |chapterable|
      mentor_profile.account.chapterable_assignments.find_or_create_by(
        profile: mentor_profile,
        chapterable: chapterable,
        season: Season.current.year,
        primary: false
      )
    end
  end

  private

  attr_accessor :mentor_profile, :team

  def chapterables_not_assigned_to_mentor
    student_chapterable_assignments.uniq.reject do |student_chapterable_assignment|
      mentor_chapterable_assignments.any? do |mentor_chapterable_assignment|
        mentor_chapterable_assignment.chapterable_type == student_chapterable_assignment.chapterable_type &&
          mentor_chapterable_assignment.chapterable_id == student_chapterable_assignment.chapterable_id
      end
    end
      .reject(&:blank?)
      .map(&:chapterable)
  end

  def mentor_chapterable_assignments
    mentor_profile.account.current_chapterable_assignments
  end

  def student_chapterable_assignments
    team.students.flat_map do |student|
      student.account.current_chapterable_assignment
    end
  end
end
