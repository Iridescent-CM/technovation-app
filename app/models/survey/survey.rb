class Survey
  class << self
    def hide_all
      hide_pre_program
      hide_post_program
    end

    def show_pre_program
      setting.reset('pre_program_survey', true)
      setting.reset('post_program_survey', false)
    end

    def hide_pre_program
      setting.reset('pre_program_survey', false)
    end

    def show_post_program
      setting.reset('post_program_survey', true)
      setting.reset('pre_program_survey', false)
    end

    def hide_post_program
      setting.reset('post_program_survey', false)
    end

    private
    def setting
      Setting
    end
  end
end
