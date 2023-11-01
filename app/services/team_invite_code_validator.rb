class TeamInviteCodeValidator
  def initialize(team_invite_code:, important_dates: ImportantDates)
    @team_invite_code = team_invite_code
    @important_dates = important_dates
  end

  def call
    invite = TeamMemberInvite.find_by(invite_token: team_invite_code)

    if invite.present? && invite.pending? && invite.inviter_type == "StudentProfile" &&
        (important_dates.official_start_of_season..important_dates.submission_deadline).cover?(Date.today)

      registration_profile_type = case invite.invitee_type
      when "StudentProfile"
        "student"
      when "MentorProfile"
        "mentor"
      end

      Result.new(
        valid?: true,
        registration_profile_type: registration_profile_type,
        success_message: "You have been invited to join the team \"#{invite.team_name}\"!"
      )
    else
      Result.new(valid?: false, registration_profile_type: "", error_message: "This invite is no longer valid.")
    end
  end

  private

  Result = Struct.new(:valid?, :registration_profile_type, :success_message, :error_message, keyword_init: true)

  attr_reader :team_invite_code, :important_dates
end
