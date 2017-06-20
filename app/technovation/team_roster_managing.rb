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
    # TODO: move to delegating actor
    team.send("add_#{scope}", profile)
  end

  def remove_member
    Casting.delegating(team => MembershipsManager) do
      team.destroy_membership(profile)
      team.delete_invitations(scope, profile)
      team.delete_join_requests(scope, profile)
    end

    # TODO: move to delegating actor
    team.reconsider_division
    team.save
  end

  private
  module MembershipsManager
    def destroy_membership(profile)
      memberships.find_by(member: profile).destroy
    end

    def delete_invitations(scope, profile)
      if scope == :student and
           invite = profile.team_member_invites.find_by(team_id: id)
        invite.deleted!
      end
    end

    def delete_join_requests(scope, profile)
      if scope == :student and
          join_request = profile.join_requests.find_by(joinable: self)
        join_request.deleted!
      end
    end
  end
end
