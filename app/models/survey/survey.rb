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

    def showing_pre_program_link?
      setting.find_by(key: 'pre_program_survey').value == 'true'
    end

    def showing_post_program_link?
      setting.find_by(key: 'post_program_survey').value == 'true'
    end

    def toggle_pre_program
      showing_pre_program_link? ? hide_pre_program : show_pre_program
    end

    def toggle_post_program
      showing_post_program_link? ? hide_post_program : show_post_program
    end


    private
    def setting
      Setting
    end
  end
end
