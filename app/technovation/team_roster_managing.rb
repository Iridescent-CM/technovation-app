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
        team.send("add_#{scope}", profile)
      end
    end
  end

  def remove_member
    profiles.each do |profile|
      scope = profile.class.name.underscore

      Casting.delegating(team => MembershipsManager) do
        team.send("remove_#{scope}", profile)
      end
    end
  end

  private
  module MembershipsManager
    def add_student_profile(student)
      if not students.include?(student) and spot_available?
        students << student

        Casting.delegating(self => DivisionChooser) do
          reconsider_division_with_save
        end

        if invite = student.team_member_invites.pending.find_by(team_id: id)
          invite.accepted!
        end

        if join_request = student.join_requests.pending.find_by(joinable: self)
          join_request.approved!
        end
      elsif students.include?(student)
        errors.add(:add_student, "Student is already on this team")
      elsif not spot_available?
        errors.add(:add_student, "No spot available to add this student")
      end
    end

    def add_mentor_profile(mentor)
      mentors << mentor

      if invite = mentor.mentor_invites.pending.find_by(team_id: id)
        invite.accepted!
      end

      if join_request = mentor.join_requests.pending.find_by(joinable: self)
        join_request.approved!
      end
    end

    def remove_student_profile(student)
      memberships.find_by(member: student).destroy

      Casting.delegating(self => DivisionChooser) do
        reconsider_division_with_save
      end

      if invite = student.team_member_invites.find_by(team_id: id)
        invite.deleted!
      end

      if join_request = student.join_requests.find_by(joinable: self)
        join_request.deleted!
      end
    end

    def remove_mentor_profile(mentor)
      memberships.find_by(member: mentor).destroy

      if invite = mentor.mentor_invites.find_by(team_id: id)
        invite.deleted!
      end

      if join_request = mentor.join_requests.find_by(joinable: self)
        join_request.deleted!
      end
    end
  end
end
