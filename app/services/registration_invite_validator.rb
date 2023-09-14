class RegistrationInviteValidator
  def initialize(invite_code:)
    @invite_code = invite_code
  end

  def call
    invite = UserInvitation.find_by(admin_permission_token: invite_code)

    if invite.present? && invite.pending?
      if invite.student? && SeasonToggles.student_registration_open?
        return Result.new(valid?: true, profile_type: "student", friendly_profile_type: "student")
      elsif invite.mentor? && SeasonToggles.mentor_registration_open?
        return Result.new(valid?: true, profile_type: "mentor", friendly_profile_type: "mentor")
      elsif invite.judge? && SeasonToggles.judge_registration_open?
        return Result.new(valid?: true, profile_type: "judge", friendly_profile_type: "judge")
      elsif invite.chapter_ambassador?
        return Result.new(valid?: true, profile_type: "chapter_ambassador", friendly_profile_type: "chapter ambassador")
      end
    end

    Result.new(valid?: false, profile_type: "", friendly_profile_type: "")
  end

  private

  Result = Struct.new(:valid?, :profile_type, :friendly_profile_type, keyword_init: true)

  attr_reader :invite_code
end
