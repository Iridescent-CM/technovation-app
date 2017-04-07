class CreateJudgeProfilesRegionalPitchEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :judge_profiles_regional_pitch_events, id: false do |t|
      t.references :judge_profile, uniq: true
      t.references :regional_pitch_event, uniq: true
    end
  end
end
