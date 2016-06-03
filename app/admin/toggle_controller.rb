class ToggleController < ActionController::Base

  def self.pre_program_survey
    pre_program_survey = Setting.find_by_key!('pre_program_survey')
    pre_program_survey.update(value: pre_program_survey.value == 'true' ? 'false' : 'true')
  end

end
