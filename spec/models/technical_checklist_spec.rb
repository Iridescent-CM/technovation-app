require "rails_helper"

RSpec.describe TechnicalChecklist do
  it "counts the total verified" do
    tc = TechnicalChecklist.create!({
      # Coding --- 1 pt each, 4 pts max
      used_strings: true,
      used_strings_explanation: "hello",
      used_strings_verified: true,

      used_numbers: true,
      used_numbers_explanation: "hello",
      used_numbers_verified: true,

      used_variables: true,
      used_variables_explanation: "hello",
      used_variables_verified: true,

      used_lists: true,
      used_lists_explanation: "hello",
      used_lists_verified: true,

      used_booleans: true,
      used_booleans_explanation: "hello",
      used_booleans_verified: true,

      used_loops: true,
      used_loops_explanation: "hello",
      used_loops_verified: true,

      used_conditionals: true,
      used_conditionals_explanation: "hello",
      used_conditionals_verified: true,

      # Databases --- 1 pt each, 1 pt max
      used_local_db: true,
      used_local_db_explanation: "hello",
      used_local_db_verified: true,

      used_external_db: true,
      used_external_db_explanation: "hello",
      used_external_db_verified: true,

      # Mobile --- 2 pts each, 2 pts max
      used_location_sensor: true,
      used_location_sensor_explanation: "hello",
      used_location_sensor_verified: true,

      used_camera: true,
      used_camera_explanation: "hello",
      used_camera_verified: true,

      used_accelerometer: true,
      used_accelerometer_explanation: "hello",
      used_accelerometer_verified: true,

      used_sms_phone: true,
      used_sms_phone_explanation: "hello",
      used_sms_phone_verified: true,

      used_sound: true,
      used_sound_explanation: "hello",
      used_sound_verified: true,

      used_sharing: true,
      used_sharing_explanation: "hello",
      used_sharing_verified: true,

      used_clock: true,
      used_clock_explanation: "hello",
      used_clock_verified: true,

      used_canvas: true,
      used_canvas_explanation: "hello",
      used_canvas_verified: true,

      # Pictures - ALL 3 for points
      paper_prototype_verified: true,
      event_flow_chart_verified: true,
    })

    team = FactoryGirl.create(:team)
    tc.create_team_submission!({
      integrity_affirmed: true,
      team: team,
    })

    2.times { tc.team_submission.screenshots.create! }

    tc.update_columns({
      paper_prototype: "foo.png",
      event_flow_chart: "bar.png",
    })

    expect(tc.total_verified).to eq(10)
  end

  it "does not count process points unless all 3 are present" do
    tc = TechnicalChecklist.create!({
      event_flow_chart_verified: true,
    })

    team = FactoryGirl.create(:team)
    tc.create_team_submission!({
      integrity_affirmed: true,
      team: team,
    })

    tc.update_column(:event_flow_chart, "bar.png")
    expect(tc.total_verified).to eq(0)
    # No screenshots, no paper prototype

    tc.update_column(:paper_prototype, "foo.png")
    expect(tc.total_verified).to eq(0)
    # No screenshots, paper prototype not verified

    tc.update_column(:paper_prototype_verified, true)
    expect(tc.total_verified).to eq(0)
    # No screenshots, paper prototype verified

    tc.team_submission.screenshots.create!
    expect(tc.total_verified).to eq(0)
    # Only 1 screenshot

    tc.team_submission.screenshots.create!
    expect(tc.total_verified).to eq(3)
    # 2 screenshots, all 3 present and verified

    tc.team_submission.screenshots.create!
    expect(tc.total_verified).to eq(3)
    # More than 2 screenshots
  end
end
