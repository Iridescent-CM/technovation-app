require "forwardable"

class TechnovationFeature
  attr_reader :feature

  extend Forwardable
  def_delegators :@feature,
    :gerundize,
    :disabled_by_staff?,
    :requires_action?,
    :requires_onboarding?,
    :only_requires_action?,
    :actions_required_as_html_list,
    :onboarding_steps_required_as_html_list

  def initialize(profile, feature_name)
    @feature = if feature_name.is_a?(TechnovationFeature)
      feature_name.feature
    else
      Feature.for(profile, feature_name)
    end

    freeze
  end

  def explanation(status)
    send("explanation_for_#{status}")
  rescue NoMethodError => e
    if e.receiver === self
      "[private method TechnovationFeature#explanation_for_#{status} is missing]"
    else
      raise e
    end
  end

  def partial_path
    if feature.available?
      "slots/#{feature.profile_scope_name}/available/#{feature.name}"
    else
      "explanations/feature_not_available"
    end
  end

  def partial_locals
    {feature: self}
  end

  private

  def explanation_for_not_available
    if feature.disabled_by_staff?
      "Technovation staff has disabled this feature for everyone."
    elsif feature.requires_onboarding?
      "You need to finish some required steps to continue."
    elsif feature.only_requires_action?
      "This feature requires some more action on your part."
    else
      "[Error] This feature should be available. Please report this to the developers."
    end
  end

  class Feature
    attr_reader :profile

    def self.for(profile, feature_name)
      "technovation_feature/#{feature_name}_feature".camelize.constantize.new(profile)
    end

    def initialize(profile)
      @profile = profile
    end

    def to_s
      feature_name
    end

    def name
      feature_name
    end

    def profile_scope_name
      profile.scope_name
    end

    def available?
      !disabled_by_staff? && !requires_onboarding? && !actions_remaining?
    end

    def actions_remaining?
      false
    end

    def disabled_by_staff?
      SeasonToggles.disabled?(self)
    end

    def requires_action?
      false
    end

    def requires_onboarding?
      !profile.onboarded?
    end

    def only_requires_action?
      requires_action? && !requires_onboarding? && !disabled_by_staff?
    end

    def feature_name
      self.class.name.demodulize.underscore.sub("_feature", "")
    end

    def onboarding_steps_required
      @onboarding_steps_required ||= OnboardingStepsRequired.new(self)
    end

    def onboarding_steps_required_as_html_list
      onboarding_steps_required.as_html_list
    end
  end

  module ActionRequiredFeature
    extend ActiveSupport::Concern

    attr_reader :actions_required

    included do
      instance_variable_set(:@actions_required_by_name, [])
      instance_variable_set(:@actions_required_with_options, {})
    end

    module ClassMethods
      def actions_required(*action_names, **action_names_with_options)
        instance_variable_set(:@actions_required_by_name, action_names)
        instance_variable_set(:@actions_required_with_options, action_names_with_options)
      end
    end

    def requires_action?
      true
    end

    def actions_completed?
      actions_required.any? &&
        actions_required.all? { |a| profile.has_completed_action?(a) }
    end

    def actions_remaining?
      !actions_completed?
    end

    def actions_required
      @actions_required ||= ActionsRequired.new(self, self.class.instance_variable_get(:@actions_required_by_name))
    end

    def actions_required_as_html_list
      actions_required.as_html_list
    end
  end

  class JoinTeamFeature < Feature
    def gerundize
      "Joining a team"
    end

    def requires_onboarding?
      !profile.can_join_a_team?
    end
  end

  class CreateTeamFeature < Feature
    def gerundize
      "Creating a team"
    end

    def requires_onboarding?
      !profile.can_create_a_team?
    end
  end

  class TeamInvitesFeature < Feature
    def gerundize
      "Responding to team invites"
    end
  end

  class SubmissionsFeature < Feature
    include ActionRequiredFeature
    actions_required :join_team

    def gerundize
      "Submitting your project"
    end
  end

  class EventsFeature < Feature
    include ActionRequiredFeature
    actions_required :join_team

    def gerundize
      "Selecting an event"
    end
  end

  class ScoresFeature < Feature
    include ActionRequiredFeature
    actions_required :join_team

    def gerundize
      "Reading your scores and certificates"
    end
  end
end
