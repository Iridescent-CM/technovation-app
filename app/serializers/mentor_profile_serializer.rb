class MentorProfileSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  set_id :random_id

  attributes :school_company_name, :job_title, :bio

  attribute :is_onboarded do |mentor|
    mentor.onboarded?
  end

  attribute :is_training_complete do |mentor|
    mentor.training_complete?
  end

  attribute(:next_onboarding_step) do |mentor|
    case mentor.onboarding_steps.first
    when :training_complete_or_not_required?
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
