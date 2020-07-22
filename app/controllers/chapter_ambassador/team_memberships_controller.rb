module ChapterAmbassador
  class TeamMembershipsController < ChapterAmbassadorController
    def create
      team = Team.find(params.fetch(:team_id))
      account = Account.find(params.fetch(:account_id))

      profile = account.mentor_profile || account.student_profile

      TeamRosterManaging.add(team, profile)

      msg = if team.members.include?(profile)
              {
                success: "You have added #{account.full_name} " +
                         "to #{team.name}",
              }
            elsif account.student_profile
              { alert: team.errors[:add_student][0] }
            else
              { alert: "An error occurred." }
            end

      redirect_to chapter_ambassador_participant_path(account), msg
    end

    def destroy
      team = Team.find(params.fetch(:id))
      member = team.memberships.find_by(
        member_id: params.fetch(:member_id),
        member_type: params.fetch(:member_type),
      ).member

      TeamRosterManaging.remove(team, member)

      redirect_to chapter_ambassador_team_path(
        team,
        allow_out_of_region: params.fetch(:allow_out_of_region) { false }
      ),
        success: "You have removed #{member.name} from this team"
    end
  end
end
