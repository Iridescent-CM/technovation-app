class CreateTechnicalChecklists < ActiveRecord::Migration[4.2]
  def change
    create_table :technical_checklists do |t|
      t.boolean :used_strings
      t.string :used_strings_explanation
      t.boolean :used_strings_verified

      t.boolean :used_numbers
      t.string :used_numbers_explanation
      t.boolean :used_numbers_verified

      t.boolean :used_variables
      t.string :used_variables_explanation
      t.boolean :used_variables_verified

      t.boolean :used_lists
      t.string :used_lists_explanation
      t.boolean :used_lists_verified

      t.boolean :used_booleans
      t.string :used_booleans_explanation
      t.boolean :used_booleans_verified

      t.boolean :used_loops
      t.string :used_loops_explanation
      t.boolean :used_loops_verified

      t.boolean :used_conditionals
      t.string :used_conditionals_explanation
      t.boolean :used_conditionals_verified

      t.boolean :used_local_db
      t.string :used_local_db_explanation
      t.boolean :used_local_db_verified

      t.boolean :used_external_db
      t.string :used_external_db_explanation
      t.boolean :used_external_db_verified

      t.boolean :used_location_sensor
      t.string :used_location_sensor_explanation
      t.boolean :used_location_sensor_verified

      t.boolean :used_camera
      t.string :used_camera_explanation
      t.boolean :used_camera_verified

      t.boolean :used_accelerometer
      t.string :used_accelerometer_explanation
      t.boolean :used_accelerometer_verified

      t.boolean :used_sms_phone
      t.string :used_sms_phone_explanation
      t.boolean :used_sms_phone_verified

      t.boolean :used_sound
      t.string :used_sound_explanation
      t.boolean :used_sound_verified

      t.boolean :used_screen_orientation
      t.string :used_screen_orientation_explanation
      t.boolean :used_screen_orientation_verified

      t.string :paper_prototype
      t.references :team_submission, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
