class TeamRosterManaging
  private

  attr_reader :team, :profiles

  public

  def initialize(team, profiles)
    @team = team
    @profiles = Array(profiles)
  end

  def self.add(team, profiles)
    new(team, profiles).add_member
  end

  def self.remove(team, members)
    new(team, members).remove_member
  end

  def add_member
    profiles.each do |profile|
      scope = profile.class.name.underscore

      Casting.delegating(team => MembershipsManager) do
        team.send(:"add_#{scope}", profile)
      end
    end
  end

  def remove_member
    profiles.each do |profile|
      scope = profile.class.name.underscore

      Casting.delegating(team => MembershipsManager) do
        team.send(:"remove_#{scope}", profile)
      end
    end

    team.destroy if Membership.where(team: team).count.zero?
  end

  private

  module MembershipsManager
    def add_student_profile(student)
      if !students.include?(student) and spot_available?
        students << student

        Casting.delegating(self => DivisionChooser) do
          reconsider_division_with_save
        end

        if invite = student.team_member_invites
            .pending.find_by(team: self)
          invite.accepted!
        end

        if join_request = student.join_requests
            .pending.find_by(team: self)
          join_request.approved!
        end

        student.account.create_activity(
          key: "account.join_team",
          recipient: self
        )

        update_column(:has_students, true)
      elsif students.include?(student)
        errors.add(:add_student, "Student is already on this team")
      elsif !spot_available?
        errors.add(:add_student, "No spot available to add this student")
      end
    end

    def add_mentor_profile(mentor)
      unless mentors.include?(mentor)
        mentors << mentor
      end

      if invite = mentor.mentor_invites.pending.find_by(team: self)
        invite.accepted!
      end

      if join_request = mentor.join_requests.pending.find_by(team: self)
        join_request.approved!
      end

      MentorToTeamChapterableAssignerJob.perform_later(mentor_profile_id: mentor.id, team_id: id)

      mentor.account.create_activity(
        key: "account.join_team",
        recipient: self
      )

      update_column(:has_mentor, true)
    end

    def remove_student_profile(student)
      memberships.find_by(member: student).destroy

      Casting.delegating(self => DivisionChooser) do
        reconsider_division_with_save
      end

      if invite = student.team_member_invites.find_by(team: self)
        invite.deleted!
      end

      if join_request = student.join_requests.find_by(team: self)
        join_request.deleted!
      end

      student.account.create_activity(
        key: "account.leave_team",
        recipient: self
      )

      update_column(:has_students, students.reload.any?)
    end

    def remove_mentor_profile(mentor)
      memberships.find_by(member: mentor).destroy

      if invite = mentor.mentor_invites.find_by(team: self)
        invite.deleted!
      end

      if join_request = mentor.join_requests.find_by(team: self)
        join_request.deleted!
      end

      MentorChapterableAssignmentsScrubberJob.perform_later(mentor_profile_id: mentor.id)

      mentor.account.create_activity(
        key: "account.leave_team",
        recipient: self
      )

      update_column(:has_mentor, mentors.reload.any?)
    end
  end
end
