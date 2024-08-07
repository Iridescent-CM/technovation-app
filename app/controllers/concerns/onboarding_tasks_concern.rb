module OnboardingTasksConcern
  extend ActiveSupport::Concern

  def incomplete_onboarding_tasks
    required_onboarding_tasks.reject { |_, completed| completed }.keys
  end
end
