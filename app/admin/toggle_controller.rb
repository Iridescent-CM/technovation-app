class ToggleController < ActionController::Base

  def self.pre_program_survey
    pre_program_survey = Setting.find_by_key!('pre_program_survey')
    pre_program_survey.value == 'true' ? Survey.hide_pre_program : Survey.show_pre_program
  end

  def self.post_program_survey
    post_program_survey = Setting.find_by_key!('post_program_survey')
    post_program_survey.value == 'true' ? Survey.hide_post_program : Survey.show_post_program
  end

end
