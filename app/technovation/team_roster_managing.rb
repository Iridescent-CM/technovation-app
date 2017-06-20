class TeamRosterManaging
  private
  attr_reader :team, :scope, :profile

  public
  def initialize(team, scope, profile)
    @team = team
    @scope = scope
    @profile = profile
  end

  def self.add(team, scope, profile)
    new(team, scope, profile).add_member
  end

  def self.remove(team, scope, member)
    new(team, scope, member).remove_member
  end

  def add_member
    Casting.delegating(team => MembershipsManager) do
      team.accept_pending_invitation(scope, profile)
      team.approve_pending_join_request(profile)

      case scope.to_sym
      when :student
        team.add_student(profile)
      when :mentor
        team.add_mentor(profile)
      else
        raise "Unsupported team member scope: #{scope}"
      end
    end
  end

  def remove_member
    Casting.delegating(team => MembershipsManager) do
      team.destroy_membership(profile)
      team.delete_invitations(scope, profile)
      team.delete_join_requests(scope, profile)

      Casting.delegating(team => DivisionChooser) do
        team.reconsider_division_with_save
      end
    end
  end

  private
  module MembershipsManager
    def add_student(student)
      if not students.include?(student) and spot_available?
        students << student

        Casting.delegating(self => DivisionChooser) do
          reconsider_division_with_save
        end
      elsif students.include?(student)
        errors.add(:add_student, "Student is already on this team")
      elsif not spot_available?
        errors.add(:add_student, "No spot available to add this student")
      end
    end

    def add_mentor(mentor)
      mentors << mentor
      save
    end

    def destroy_membership(profile)
      memberships.find_by(member: profile).destroy
    end

    def delete_invitations(scope, profile)
      invites_method = scope.to_sym == :student ?
        :team_member_invites :
        :mentor_invites

      if invite = profile.send(invites_method).find_by(team_id: id)
        invite.deleted!
      end
    end

    def delete_join_requests(scope, profile)
      if join_request = profile.join_requests.find_by(joinable: self)
        join_request.deleted!
      end
    end

    def accept_pending_invitation(scope, profile)
      invites_method = scope.to_sym == :student ?
        :team_member_invites :
        :mentor_invites

      if invite = profile.send(invites_method).pending.find_by(team_id: id)
        invite.accepted!
      end
    end

    def approve_pending_join_request(profile)
      if join_request = profile.join_requests.pending.find_by(joinable: self)
        join_request.approved!
      end
    end
  end
end
