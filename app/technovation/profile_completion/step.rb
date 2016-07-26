module ProfileCompletion
  class Step
    include ActionView::Helpers::TagHelper
    include FontAwesome::Rails::IconHelper

    attr_reader :links, :complete_condition

    attr_accessor :completion_status

    def initialize(id, label_path, prerequisites, complete_condition, links)
      @id = id
      @label_path = label_path
      @prerequisites = prerequisites
      @complete_condition = complete_condition
      @links = links
    end

    def label
      I18n.t(@label_path)
    end

    def checkmark
      case completion_status
      when "complete"
        fa_icon("check 2x")
      else
        ""
      end
    end
  end
end
