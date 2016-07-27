module ProfileCompletion
  class Step
    include ActionView::Helpers::TagHelper
    include FontAwesome::Rails::IconHelper

    COMPLETION_STATES = {
      complete: "complete",
      ready: "ready",
      future: "future",
    }

    attr_reader :id
    attr_reader :links
    attr_reader :complete_condition
    attr_reader :completion_status

    def initialize(id, prerequisites, complete_condition, links)
      @id = id
      @prerequisites = prerequisites.split(", ").flatten.compact
      @complete_condition = complete_condition
      @links = links
    end

    def label
      I18n.t("views.profile_requirements.#{@id}.label")
    end

    def set_account_options(account)
      @completion_status = account.send(complete_condition) ?
                             COMPLETION_STATES[:complete] :
                             COMPLETION_STATES[:ready]

      unless prerequisites_met?
        @completion_status = COMPLETION_STATES[:future]
      end
    end

    def ready?
      completion_status == COMPLETION_STATES[:ready]
    end

    def incomplete?
      completion_status != COMPLETION_STATES[:complete]
    end

    def complete?
      not incomplete?
    end

    def checkmark
      case completion_status
      when COMPLETION_STATES[:complete]
        fa_icon("check 2x")
      else
        ""
      end
    end

    private
    def prerequisites_met?
      @prerequisites.all? do |prereq|
        ProfileCompletion.step(prereq).complete?
      end
    end
  end
end
