class OnboardingStepRequired
  attr_reader :step

  def initialize(step)
    @step = step
    freeze
  end

  def to_s
    name
  end

  def name
    step
  end

  def message
    case step
    when :email_confirmed?
      "You need to confirm your new email address."
    when :training_complete_or_not_required?
      "You must complete the mentor training"
    when :consent_signed?
      "You need to sign the consent waiver"
    when :parental_consent_signed?
      "<a href='dashboard#/parental-consent'>You need permission from your parent or guardian</a>"
    when :background_check_complete?
      "You must pass a background check"
    when :bio_complete?
      "You must complete your personal summary"
    when :mentor_type_complete?
      "You must select a mentor type"
    else
      "[Error] OnboardingStepRequired#message is missing for `:#{step}`"
    end
  end
end
