class RegistrationCreateGate
  VALID_PROFILE_TYPES = %w[
    student
    parent
    mentor
    judge
    chapter_ambassador
    club_ambassador
  ].freeze

  PROFILE_TYPE_TO_TOGGLE = {
    "student" => :student_registration_open?,
    "parent" => :student_registration_open?,
    "mentor" => :mentor_registration_open?,
    "judge" => :judge_registration_open?,
    "chapter_ambassador" => :chapter_ambassador_registration_open?,
    "club_ambassador" => :club_ambassador_registration_open?
  }.freeze

  Result = Struct.new(:valid?, :errors, keyword_init: true)

  def initialize(profile_type:, invite_code: nil, team_invite_code: nil)
    @profile_type = profile_type.to_s
    @invite_code = invite_code.presence
    @team_invite_code = team_invite_code.presence
  end

  def call
    unless VALID_PROFILE_TYPES.include?(profile_type)
      return Result.new(valid?: false, errors: ["Invalid profile type"])
    end

    if profile_type_registration_open?
      return Result.new(valid?: true, errors: [])
    end

    if invite_code.present?
      return invite_validation_result
    end

    if team_invite_code.present?
      return team_invite_validation_result
    end

    Result.new(
      valid?: false,
      errors: ["Registration is not open for this profile type"]
    )
  end

  private

  attr_reader :profile_type, :invite_code, :team_invite_code

  def profile_type_registration_open?
    SeasonToggles.public_send(PROFILE_TYPE_TO_TOGGLE.fetch(profile_type))
  end

  def invite_validation_result
    result = RegistrationInviteCodeValidator.new(invite_code: invite_code).call

    if result.valid? && result.registration_profile_type == profile_type
      Result.new(valid?: true, errors: [])
    elsif result.valid?
      Result.new(
        valid?: false,
        errors: ["This invitation does not match the selected profile type"]
      )
    else
      Result.new(valid?: false, errors: [result.error_message])
    end
  end

  def team_invite_validation_result
    result = TeamInviteCodeValidator.new(team_invite_code: team_invite_code).call

    if result.valid? && team_invite_allows_profile_type?(result.registration_profile_type)
      Result.new(valid?: true, errors: [])
    elsif result.valid?
      Result.new(
        valid?: false,
        errors: ["This team invitation does not match the selected profile type"]
      )
    else
      Result.new(valid?: false, errors: [result.error_message])
    end
  end

  def team_invite_allows_profile_type?(invite_profile_type)
    case invite_profile_type
    when "student"
      %w[student parent].include?(profile_type)
    when "mentor"
      profile_type == "mentor"
    else
      false
    end
  end
end
