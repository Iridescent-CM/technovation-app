require "rails_helper"

RSpec.feature "Students edit submission pieces" do
  let!(:student) { FactoryBot.create(:onboarded_student, :senior, :on_team) }
  let!(:mentor) { FactoryBot.create(:mentor) }
  let!(:submission) {
    FactoryBot.create(:team_submission, team: student.team)
  }

  before do
    SeasonToggles.team_submissions_editable!
    TeamRosterManaging.add(student.team, mentor)
    sign_in(mentor)
    click_link "Edit this team's submission"
  end

  scenario "Set the app name" do
    within(".app_name.incomplete") do
      click_link "Set your app's name"
    end

    fill_in "Your app's name", with: "WonderApp2018"
    click_button "Save this name"

    within(".app_name.complete") do
      expect(page).not_to have_link("Set your app's name")

      expect(page).to have_content "WonderApp2018"
      expect(page).to have_link(
        "Change your app's name",
        href: edit_mentor_team_submission_path(submission.reload, piece: :app_name)
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

    within(".app_description.complete") do
      expect(page).not_to have_link("Add your app's description")

      expect(page).to have_content "Only a few sentences"
      expect(page).to have_link(
        "Change your app's description",
        href: edit_mentor_team_submission_path(submission, piece: :app_description)
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

    within(".demo_video_link.complete") do
      expect(page).not_to have_link("Add your app's description")

      embed_url = "https://www.youtube.com/embed/#{video_id}?rel=0&cc_load_policy=1"
      expect(page).to have_css "iframe[src='#{embed_url}']"
      expect(page).to have_link(
        "Change the demo video link",
        href: edit_mentor_team_submission_path(submission, piece: :demo_video_link)
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

    within(".pitch_video_link.complete") do
      expect(page).not_to have_link("Add your app's description")

      embed_url = "https://www.youtube.com/embed/#{video_id}?rel=0&cc_load_policy=1"
      expect(page).to have_css "iframe[src='#{embed_url}']"
      expect(page).to have_link(
        "Change the pitch video link",
        href: edit_mentor_team_submission_path(submission, piece: :pitch_video_link)
      )
    end
  end

  scenario "Set the devleopment platform" do
    within(".development_platform.incomplete") do
      click_link "Select the development platform that your team used"
    end

    select "Swift or XCode", from: "Which development platform did your team use?"

    click_button "Save this development platform selection"

    within(".development_platform.complete") do
      expect(page).not_to have_link("Select the development platform that your team used")

      expect(page).to have_content "Swift or XCode"
      expect(page).to have_link(
        "Change your selection",
        href: edit_mentor_team_submission_path(submission, piece: :development_platform)
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

    within(".source_code.complete") do
      expect(page).not_to have_link("Upload your app's source code")

      expect(page).to have_link(
        "source_code.zip",
        href: submission.reload.source_code_url
      )
      expect(page).to have_link(
        "Change your upload",
        href: edit_mentor_team_submission_path(submission, piece: :source_code)
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

    within(".source_code.complete") do
      expect(page).not_to have_link("Upload your app's source code")

      expect(page).to have_link(
        "source_code.aia",
        href: submission.reload.source_code_url
      )
      expect(page).to have_link(
        "Change your upload",
        href: edit_mentor_team_submission_path(submission, piece: :source_code)
      )
    end
  end

  scenario "Upload a .pdf business plan" do
    within(".business_plan.incomplete") do
      click_link "Upload your team's business plan"
    end

    attach_file(
      "Upload your team's business plan",
      Rails.root + "spec/support/fixtures/business_plan.pdf"
    )

    click_button "Upload"

    within(".business_plan.complete") do
      expect(page).not_to have_link("Upload your team's business plan")

      expect(page).to have_link(
        "business_plan.pdf",
        href: submission.reload.business_plan_url
      )
      expect(page).to have_link(
        "Change your upload",
        href: edit_mentor_team_submission_path(submission, piece: :business_plan)
      )
    end
  end

  scenario "Upload 2 .jpg screenshots" do
    within(".screenshots.incomplete") do
      click_link "Upload screenshots of your app"
    end

    attach_file(
      "Select up to 6 screenshots",
      Rails.root + "spec/support/fixtures/screenshot.jpg"
    )

    click_button "Upload"

    within(".screenshots.complete") do
      expect(page).not_to have_link("Upload screenshots of your app")

      expect(page).to have_content("Your team has uploaded 1 screenshot")

      click_link "Make changes to your screenshots"
    end

    within(find_all(".field--file-upload")[1]) do
      attach_file(
        "Select up to 6 screenshots",
        Rails.root + "spec/support/fixtures/screenshot2.jpg"
      )
    end

    click_button "Upload"

    within(".screenshots.complete") do
      expect(page).to have_content("Your team has uploaded 2 screenshots")
    end
  end
end
