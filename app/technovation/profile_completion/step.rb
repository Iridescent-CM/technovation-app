module ProfileCompletion
  class Step
    include ActionView::Helpers::TagHelper
    include FontAwesome::Rails::IconHelper
    include Rails.application.routes.url_helpers

    COMPLETION_STATES = {
      complete: "complete",
      ready: "ready",
      future: "future",
    }

    attr_reader :id
    attr_reader :complete_condition
    attr_reader :completion_status
    attr_reader :unlocks

    def initialize(id, prerequisites, complete_condition, unlocks)
      @id = id
      @prerequisites = prerequisites.split(", ").flatten.compact
      @complete_condition = complete_condition
      @unlocks = unlocks.split(", ").flatten.compact
    end

    def label
      I18n.t("views.profile_requirements.#{@id}.label")
    end

    def set_account_options(account)
      @completion_status = account.send(complete_condition) ?
                             COMPLETION_STATES[:complete] :
                             COMPLETION_STATES[:ready]

      @prerequisites.each do |prereq|
        ProfileCompletion.step(prereq).set_account_options(account)
      end

      unless prerequisites_met?
        @completion_status = COMPLETION_STATES[:future]
      end
    end

    def unlocks?(account, path)
      unlocks.any? { |u| Array(path).include?(compute_path(account, u)) }
    end

    def ready?
      completion_status == COMPLETION_STATES[:ready]
    end

    def future?
      completion_status == COMPLETION_STATES[:future]
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

    def compute_path(account, unlock_path)
      case unlock_path
      when /\[/
        path_parts = unlock_path.sub(']', '').split('[')
        path_method = path_parts.first
        if path_arg = account.public_send(path_parts.last)
          send(path_method, path_arg)
        else
          ""
        end
      else
        send(unlock_path)
      end
    end
  end
end
