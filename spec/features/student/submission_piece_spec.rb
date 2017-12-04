require "rails_helper"

RSpec.feature "Students edit submission pieces" do
  let!(:student) { FactoryBot.create(:onboarded_student, :on_team) }
  let!(:submission) { student.team.team_submissions.create!({ integrity_affirmed: true }) }

  before do
    SeasonToggles.team_submissions_editable!
    sign_in(student)
    click_link "My team's submission"
  end

  scenario "Set the app name" do
    within(".app_name.incomplete") do
      click_link "Set your app's name"
    end

    fill_in "Your app's name", with: "WonderApp2018"
    click_button "Save this name"

    expect(current_path).to eq(student_team_submission_path(submission.reload))

    within(".app_name.complete") do
      expect(page).not_to have_link("Set your app's name")

      expect(page).to have_content "WonderApp2018"
      expect(page).to have_link(
        "Change your app's name",
        href: edit_student_team_submission_path(submission, piece: :app_name)
      )
    end
  end

  scenario "Set the app description" do
    within(".app_description.incomplete") do
      click_link "Add your app's description"
    end

    fill_in "Describe your app in only a few sentences or less",
      with: "Only a few sentences"

    click_button "Save this description"

    expect(current_path).to eq(student_team_submission_path(submission))

    within(".app_description.complete") do
      expect(page).not_to have_link("Add your app's description")

      expect(page).to have_content "Only a few sentences"
      expect(page).to have_link(
        "Change your app's description",
        href: edit_student_team_submission_path(submission, piece: :app_description)
      )
    end
  end

  scenario "Set the demo video" do
    within(".demo_video_link.incomplete") do
      click_link "Add the demo video link"
    end

    video_id = "qQTVuRrZO8w"
    fill_in "Youtube or Vimeo URL", with: "https://www.youtube.com/watch?v=#{video_id}"

    click_button "Save this demo video link"

    expect(current_path).to eq(student_team_submission_path(submission))

    within(".demo_video_link.complete") do
      expect(page).not_to have_link("Add your app's description")

      embed_url = "https://www.youtube.com/embed/#{video_id}?rel=0&cc_load_policy=1"
      expect(page).to have_css "iframe[src='#{embed_url}']"
      expect(page).to have_link(
        "Change the demo video link",
        href: edit_student_team_submission_path(submission, piece: :demo_video_link)
      )
    end
  end

  scenario "Set the pitch video" do
    within(".pitch_video_link.incomplete") do
      click_link "Add the pitch video link"
    end

    video_id = "qQTVuRrZO8w"
    fill_in "Youtube or Vimeo URL", with: "https://www.youtube.com/watch?v=#{video_id}"

    click_button "Save this pitch video link"

    expect(current_path).to eq(student_team_submission_path(submission))

    within(".pitch_video_link.complete") do
      expect(page).not_to have_link("Add your app's description")

      embed_url = "https://www.youtube.com/embed/#{video_id}?rel=0&cc_load_policy=1"
      expect(page).to have_css "iframe[src='#{embed_url}']"
      expect(page).to have_link(
        "Change the pitch video link",
        href: edit_student_team_submission_path(submission, piece: :pitch_video_link)
      )
    end
  end

  scenario "Set the devleopment platform" do
    within(".development_platform.incomplete") do
      click_link "Select the development platform that your team used"
    end

    select "Swift or XCode", from: "Which development platform did your team use?"

    click_button "Save this development platform selection"

    expect(current_path).to eq(student_team_submission_path(submission))

    within(".development_platform.complete") do
      expect(page).not_to have_link("Select the development platform that your team used")

      expect(page).to have_content "Swift or XCode"
      expect(page).to have_link(
        "Change your selection",
        href: edit_student_team_submission_path(submission, piece: :development_platform)
      )
    end
  end

  scenario "Upload the .zip source code" do
    within(".source_code.incomplete") do
      click_link "Upload your app's source code"
    end

    attach_file(
      "Upload your app's source code",
      Rails.root + "spec/support/fixtures/source_code.zip"
    )

    click_button "Upload"

    expect(current_path).to eq(student_team_submission_path(submission))

    within(".source_code.complete") do
      expect(page).not_to have_link("Upload your app's source code")

      expect(page).to have_link(
        "source_code.zip",
        href: submission.reload.source_code_url
      )
      expect(page).to have_link(
        "Change your upload",
        href: edit_student_team_submission_path(submission, piece: :source_code)
      )
    end
  end

  scenario "Upload the .aia source code" do
    within(".source_code.incomplete") do
      click_link "Upload your app's source code"
    end

    attach_file(
      "Upload your app's source code",
      Rails.root + "spec/support/fixtures/source_code.aia"
    )

    click_button "Upload"

    expect(current_path).to eq(student_team_submission_path(submission))

    within(".source_code.complete") do
      expect(page).not_to have_link("Upload your app's source code")

      expect(page).to have_link(
        "source_code.aia",
        href: submission.reload.source_code_url
      )
      expect(page).to have_link(
        "Change your upload",
        href: edit_student_team_submission_path(submission, piece: :source_code)
      )
    end
  end
end
