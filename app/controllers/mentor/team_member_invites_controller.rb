module Mentor
  class TeamMemberInvitesController < MentorController
    include TeamMemberInviteController

    def update
      if SeasonToggles.judging_enabled_or_between?
        redirect_to mentor_dashboard_path,
          alert: t("views.team_member_invites.show.invites_disabled_by_judging")
      elsif invite = current_mentor.mentor_invites.pending.find_by(
        invite_token: params.fetch(:id)
      )
        invite.update(invite_params)

        student_chapterables = invite.team.students.flat_map { |s| s.account.current_chapterable_assignment&.chapterable }.uniq

        student_chapterables.each do |chapterable|
          if chapterable.present?
            chapterable.chapterable_account_assignments.find_or_create_by(
              profile: current_mentor,
              account: current_mentor.account,
              season: Season.current.year,
              primary: false
            )
          end
        end

        redirect_based_on_status(invite)
      else
        redirect_to mentor_dashboard_path,
          alert: t("controllers.invites.update.failure")
      end
    end

    private

    def redirect_based_on_status(invite)
      if invite.accepted?
        @path = mentor_team_path(invite.team)
        @msg = t("controllers.team_member_invites.update.success")
      else
        @path = mentor_dashboard_path
        @msg = t("controllers.team_member_invites.update.not_accepted")
      end

      redirect_to @path, success: @msg
    end

    def invite_params
      params.require(:team_member_invite).permit(:status)
    end

    def current_profile
      current_mentor
    end
  end
end
