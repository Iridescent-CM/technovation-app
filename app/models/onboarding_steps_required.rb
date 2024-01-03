class OnboardingStepsRequired
  include Enumerable

  attr_reader :feature, :onboarding_steps

  def initialize(feature)
    @feature = feature
    @onboarding_steps = feature.profile.onboarding_steps
    freeze
  end

  def each(&block)
    @onboarding_steps.each { |a| block.call(::OnboardingStepRequired.new(a)) }
  end

  def as_html_list
    if feature.requires_onboarding?
      "<ul><li>#{map(&:message).join("</li><li>")}</li></ul>".html_safe
    else
      ""
    end
  end
end
