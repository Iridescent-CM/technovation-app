class RegistrationSettingsAggregator
  def initialize(invite_code: "", invite_code_validator: RegistrationInviteCodeValidator,
    team_invite_code: "", team_invite_code_validator: TeamInviteCodeValidator,
    season_toggles: SeasonToggles)

    @invite_code = invite_code
    @invite_code_validator = invite_code_validator
    @team_invite_code = team_invite_code
    @team_invite_code_validator = team_invite_code_validator
    @season_toggles = season_toggles
    @registration_settings = Result.new(
      student_registration_open?: season_toggles.student_registration_open?,
      parent_registration_open?: season_toggles.student_registration_open?,
      mentor_registration_open?: season_toggles.mentor_registration_open?,
      judge_registration_open?: season_toggles.judge_registration_open?,
      chapter_ambassador_registration_open?: false,
      invited_registration_profile_type: "",
      success_message: "",
      error_message: default_error_message
    )
  end

  def call
    validate_invite_code if invite_code.present?
    validate_team_invite_code if team_invite_code.present?

    registration_settings
  end

  private

  Result = Struct.new(
    :student_registration_open?,
    :parent_registration_open?,
    :mentor_registration_open?,
    :judge_registration_open?,
    :chapter_ambassador_registration_open?,
    :invited_registration_profile_type,
    :success_message,
    :error_message,
    keyword_init: true
  )

  attr_reader :invite_code, :invite_code_validator, :team_invite_code, :team_invite_code_validator, :season_toggles, :registration_settings

  def validate_invite_code
    validator_response = invite_code_validator.new(invite_code: invite_code).call

    if validator_response.valid?
      open_registration_for(validator_response.registration_profile_type)

      registration_settings.invited_registration_profile_type = validator_response.registration_profile_type
      registration_settings.success_message = validator_response.success_message
      registration_settings.error_message = ""
    elsif any_registration_types_open?
      registration_settings.error_message = "Sorry, this invitation is no longer valid, but you can still join Technovation as a #{enabled_registration_types.to_sentence(two_words_connector: " or ", last_word_connector: ", or ")} below."
    else
      registration_settings.error_message = validator_response.error_message
    end
  end

  def validate_team_invite_code
    validator_response = team_invite_code_validator.new(team_invite_code: team_invite_code).call

    if validator_response.valid?
      case validator_response.registration_profile_type
      when "student"
        open_registration_for("student")
        open_registration_for("parent")
      when "mentor"
        open_registration_for("mentor")
      end

      registration_settings.success_message = validator_response.success_message
      registration_settings.error_message = ""
    elsif any_registration_types_open?
      registration_settings.error_message = "Sorry, this invitation is no longer valid, but you can still join Technovation as a #{enabled_registration_types.to_sentence(two_words_connector: " or ", last_word_connector: ", or ")} below."
    else
      registration_settings.error_message = validator_response.error_message
    end
  end

  def open_registration_for(profile_type)
    case profile_type
    when "student"
      registration_settings[:student_registration_open?] = true
    when "parent"
      registration_settings[:parent_registration_open?] = true
    when "mentor"
      registration_settings[:mentor_registration_open?] = true
    when "judge"
      registration_settings[:judge_registration_open?] = true
    when "chapter_ambassador"
      registration_settings[:chapter_ambassador_registration_open?] = true
    end
  end

  def any_registration_types_open?
    enabled_registration_types.count >= 1
  end

  def enabled_registration_types
    enabled_registration_types = []

    if season_toggles.student_registration_open?
      enabled_registration_types << "student"
      enabled_registration_types << "parent"
    end

    if season_toggles.mentor_registration_open?
      enabled_registration_types << "mentor"
    end

    if season_toggles.judge_registration_open?
      enabled_registration_types << "judge"
    end

    enabled_registration_types
  end

  def disabled_registration_types
    disabled_registration_types = []

    if !season_toggles.student_registration_open?
      disabled_registration_types << "students"
    end

    if !season_toggles.mentor_registration_open?
      disabled_registration_types << "mentors"
    end

    if !season_toggles.judge_registration_open?
      disabled_registration_types << "judges"
    end

    disabled_registration_types
  end

  def default_error_message
    if disabled_registration_types.present?
      "Registration is currently closed for #{disabled_registration_types.to_sentence}."
    else
      ""
    end
  end
end
