module OnboardingTasksConcern
  extend ActiveSupport::Concern

  def incomplete_onboarding_tasks
    required_onboarding_tasks.reject { |_, completed| completed }.keys
  end

  def complete_onboarding_tasks
    required_onboarding_tasks.select { |_, completed| completed }.keys
  end
end
