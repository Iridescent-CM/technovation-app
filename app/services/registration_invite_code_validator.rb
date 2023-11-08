class RegistrationInviteCodeValidator
  def initialize(invite_code:)
    @invite_code = invite_code
  end

  def call
    invite = UserInvitation.find_by(admin_permission_token: invite_code)

    if invite.present? && invite.pending?
      if invite.student? && (SeasonToggles.student_registration_open? || invite.register_at_any_time?)
        return Result.new(
          valid?: true,
          register_at_any_time?: invite.register_at_any_time?,
          registration_profile_type: "student",
          success_message: "You have been invited to join Technovation Girls as a student!"
        )
      elsif invite.parent_student? && (SeasonToggles.student_registration_open? || invite.register_at_any_time?)
        return Result.new(
          valid?: true,
          register_at_any_time?: invite.register_at_any_time?,
          registration_profile_type: "parent",
          success_message: "You have been invited to join Technovation Girls as a parent!"
        )
      elsif invite.mentor? && (SeasonToggles.mentor_registration_open? || invite.register_at_any_time?)
        return Result.new(
          valid?: true,
          register_at_any_time?: invite.register_at_any_time?,
          registration_profile_type: "mentor",
          success_message: "You have been invited to join Technovation Girls as a mentor!"
        )
      elsif invite.judge? && (SeasonToggles.judge_registration_open? || invite.register_at_any_time?)
        return Result.new(
          valid?: true,
          register_at_any_time?: invite.register_at_any_time?,
          registration_profile_type: "judge",
          success_message: "You have been invited to join Technovation Girls as a judge!"
        )
      elsif invite.chapter_ambassador?
        return Result.new(
          valid?: true,
          register_at_any_time?: true,
          registration_profile_type: "chapter_ambassador",
          success_message: "You have been invited to join Technovation Girls as a chapter ambassador!"
        )
      end
    end

    Result.new(valid?: false, register_at_any_time?: false, registration_profile_type: "", error_message: "This invitation is no longer valid.")
  end

  private

  Result = Struct.new(:valid?, :register_at_any_time?, :registration_profile_type, :success_message, :error_message, keyword_init: true)

  attr_reader :invite_code
end
