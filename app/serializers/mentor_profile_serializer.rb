class MentorProfileSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  set_id :random_id

  attributes :school_company_name, :job_title, :bio

  attribute(:is_onboarded, &:onboarded?)

  attribute(:next_onboarding_step) do |mentor|
    case mentor.onboarding_steps.first
    when :consent_signed?
      "consent-waiver"
    when :background_check_complete?
      "background-check"
    else
      "bio"
    end
  end
end