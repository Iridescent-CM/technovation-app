module Mentor
  class MentorInvitesController < MentorController
    before_action :require_onboarded

    def show
      if SeasonToggles.judging_enabled_or_between?
        return redirect_when_invites_are_disabled_by_judging
      end

      @invite = MentorInvite.find_by(
        invite_token: params.fetch(:id)
      ) || ::NullInvite.new

      if @invite.invitee and @invite.invitee != current_profile
        signin = @invite.invitee.account
        SignIn.call(signin, self, redirect_to: [:mentor_mentor_invite_path, @invite])
      else
        render template: "team_member_invites/show_#{@invite.status}"
      end
    end

    def update
      if SeasonToggles.judging_enabled_or_between?
        redirect_when_invites_are_disabled_by_judging
      elsif invite = current_mentor.mentor_invites.pending.find_by(
        invite_token: params.fetch(:id)
      )
        invite.update(invite_params)
        redirect_based_on_status(invite)
      else
        redirect_to mentor_dashboard_path,
          alert: t("controllers.invites.update.failure")
      end
    end

    def destroy
      if SeasonToggles.judging_enabled_or_between?
        return redirect_when_invites_are_disabled_by_judging
      end

      @invite = MentorInvite.find_by(
        team_id: current_mentor.team_ids,
        invite_token: params.fetch(:id)
      )

      @invite.destroy

      redirect_back fallback_location: mentor_dashboard_path,
        success: t(
          "controllers.invites.destroy.success",
          name: @invite.invitee_name
        )
    end

    private

    def redirect_when_invites_are_disabled_by_judging
      redirect_to mentor_dashboard_path,
        alert: t("views.team_member_invites.show.invites_disabled_by_judging")
    end

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
  end
end
