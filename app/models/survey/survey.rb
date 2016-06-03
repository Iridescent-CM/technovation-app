class Survey
  class << self
    def hide_all
      setting.reset('pre_program_survey', false)
      setting.reset('post_program_survey', false)
    end

    def show_pre_program
      setting.reset('pre_program_survey', true)
      setting.reset('post_program_survey', false)
    end

    private
    def setting
      Setting
    end
  end
end
