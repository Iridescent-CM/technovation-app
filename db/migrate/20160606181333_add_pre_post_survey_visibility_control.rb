class AddPrePostSurveyVisibilityControl < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up {
        Setting.create(key: 'pre_program_survey', value: 'false')
        Setting.create(key: 'post_program_survey', value: 'false')
      }

      dir.down {
        Setting.find_by(key: 'pre_program_survey').destroy
        Setting.find_by(key: 'post_program_survey').destroy
      }
    end
  end
end
