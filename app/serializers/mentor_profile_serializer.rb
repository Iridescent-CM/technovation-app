class MentorProfileSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  set_id :random_id

  attributes :school_company_name, :job_title, :bio

  attribute(:is_onboarded, &:onboarded?)

  attribute(:is_training_complete, &:training_complete?)

  attribute(:requires_background_check, &:requires_background_check?)

  attribute(:background_check_complete, &:background_check_complete?)

  attribute(:next_onboarding_step) do |mentor|
    case mentor.onboarding_steps.first
    when :training_complete?
      "mentor-training"
    when :consent_signed?
      "consent-waiver"
    when :background_check_complete?
      "background-check"
    else
      "bio"
    end
  end
end