class MoveVerifiedColumnsFromTechnicalChecklistsToSubmissionScores < ActiveRecord::Migration[4.2]
  def change
    remove_column :technical_checklists, :used_strings_verified, :boolean
    remove_column :technical_checklists, :used_numbers_verified, :boolean
    remove_column :technical_checklists, :used_variables_verified, :boolean
    remove_column :technical_checklists, :used_lists_verified, :boolean
    remove_column :technical_checklists, :used_booleans_verified, :boolean
    remove_column :technical_checklists, :used_loops_verified, :boolean
    remove_column :technical_checklists, :used_conditionals_verified, :boolean
    remove_column :technical_checklists, :used_local_db_verified, :boolean
    remove_column :technical_checklists, :used_external_db_verified, :boolean
    remove_column :technical_checklists, :used_location_sensor_verified, :boolean
    remove_column :technical_checklists, :used_camera_verified, :boolean
    remove_column :technical_checklists, :used_accelerometer_verified, :boolean
    remove_column :technical_checklists, :used_sms_phone_verified, :boolean
    remove_column :technical_checklists, :used_sound_verified, :boolean
    remove_column :technical_checklists, :used_sharing_verified, :boolean
    remove_column :technical_checklists, :paper_prototype_verified, :boolean
    remove_column :technical_checklists, :event_flow_chart_verified, :boolean
    remove_column :technical_checklists, :used_clock_verified, :boolean
    remove_column :technical_checklists, :used_canvas_verified, :boolean

    add_column :submission_scores, :used_strings_verified, :boolean
    add_column :submission_scores, :used_numbers_verified, :boolean
    add_column :submission_scores, :used_variables_verified, :boolean
    add_column :submission_scores, :used_lists_verified, :boolean
    add_column :submission_scores, :used_booleans_verified, :boolean
    add_column :submission_scores, :used_loops_verified, :boolean
    add_column :submission_scores, :used_conditionals_verified, :boolean
    add_column :submission_scores, :used_local_db_verified, :boolean
    add_column :submission_scores, :used_external_db_verified, :boolean
    add_column :submission_scores, :used_location_sensor_verified, :boolean
    add_column :submission_scores, :used_camera_verified, :boolean
    add_column :submission_scores, :used_accelerometer_verified, :boolean
    add_column :submission_scores, :used_sms_phone_verified, :boolean
    add_column :submission_scores, :used_sound_verified, :boolean
    add_column :submission_scores, :used_sharing_verified, :boolean
    add_column :submission_scores, :paper_prototype_verified, :boolean
    add_column :submission_scores, :event_flow_chart_verified, :boolean
    add_column :submission_scores, :used_clock_verified, :boolean
    add_column :submission_scores, :used_canvas_verified, :boolean
  end
end
