require "rails_helper"

RSpec.feature "Students edit submission pieces" do
  let!(:student) {
    FactoryBot.create(:onboarded_student, :senior, :on_team)
  }
  let!(:mentor) { FactoryBot.create(:mentor, :onboarded) }
  let!(:submission) {
    FactoryBot.create(:team_submission, team: student.team)
  }

  before do
    SeasonToggles.team_submissions_editable!
    TeamRosterManaging.add(student.team, mentor)
    sign_in(mentor)
    within("#find-team #team_#{student.team.id}") { click_link "Edit this team's submission" }
  end

  scenario "Set the project name" do
    click_link "Ideation"

    within(".app_name.incomplete") do
      click_link "Set your project's name"
    end

    fill_in "Your project's name", with: "WonderApp2018"
    click_button "Save this name"

    within(".app_name.complete") do
      expect(page).not_to have_link("Set your project's name")

      expect(page).to have_content "WonderApp2018"
      expect(page).to have_link(
        "Change your project's name",
        href: edit_mentor_team_submission_path(
          submission.reload,
          piece: :app_name
        )
      )
    end
  end

  scenario "Set the project description" do
    click_link "Ideation"

    within(".app_description.incomplete") do
      click_link "Add your project's description"
    end

    fill_in "Describe your project in a few sentences (100 words or less)",
      with: "Only a few sentences"

    click_button "Save this description"

    within(".app_description.complete") do
      expect(page).not_to have_link("Add your project's description")

      expect(page).to have_content "Only a few sentences"
      expect(page).to have_link(
        "Change your project's description",
        href: edit_mentor_team_submission_path(
          submission,
          piece: :app_description
        )
      )
    end
  end

  scenario "Set the demo/technical video" do
    click_link "Pitch"

    within(".demo_video_link.incomplete") do
      click_link "Add the technical video link"
    end

    video_id = "qQTVuRrZO8w"
    fill_in "Youtube, Vimeo, or Youku URL",
      with: "https://www.youtube.com/watch?v=#{video_id}"

    click_button "Next"
    click_button "Save"

    within(".demo_video_link.complete") do
      expect(page).not_to have_link("Add your project's description")

      expect(page).to have_css "[data-modal-fetch*='piece=demo']"
      expect(page).to have_link(
        "Change the technical video link",
        href: edit_mentor_team_submission_path(
          submission,
          piece: :demo_video_link
        )
      )
    end
  end

  scenario "Set the pitch video" do
    click_link "Pitch"

    within(".pitch_video_link.incomplete") do
      click_link "Add the pitch video link"
    end

    video_id = "qQTVuRrZO8w"
    fill_in "Youtube, Vimeo, or Youku URL",
      with: "https://www.youtube.com/watch?v=#{video_id}"

    click_button "Next"
    click_button "Save"

    within(".pitch_video_link.complete") do
      expect(page).not_to have_link("Add your project's description")

      expect(page).to have_css "[data-modal-fetch*='piece=pitch']"
      expect(page).to have_link(
        "Change the pitch video link",
        href: edit_mentor_team_submission_path(
          submission,
          piece: :pitch_video_link
        )
      )
    end
  end

  scenario "Set the pitch video with youku" do
    click_link "Pitch"

    within(".pitch_video_link.incomplete") do
      click_link "Add the pitch video link"
    end

    video_id = "XMzMyNzg3OTY1Mg"
    fill_in "Youtube, Vimeo, or Youku URL",
      with: "https://v.youku.com/v_show/id_" +
        video_id +
        "==.html?spm=a2hww.20027244." +
        "m_250036.5~5!2~5~5!2~5~5~A&f=51463715"

    click_button "Next"
    click_button "Save"

    within(".pitch_video_link.complete") do
      expect(page).not_to have_link("Add your project's description")

      expect(page).to have_css "[data-modal-fetch*='piece=pitch']"
      expect(page).to have_link(
        "Change the pitch video link",
        href: edit_mentor_team_submission_path(
          submission,
          piece: :pitch_video_link
        )
      )
    end
  end

  scenario "Set the demo/technical video with youku" do
    click_link "Pitch"

    within(".demo_video_link.incomplete") do
      click_link "Add the technical video link"
    end

    video_id = "XMzMyNzg3OTY1Mg"
    fill_in "Youtube, Vimeo, or Youku URL",
      with: "https://v.youku.com/v_show/id_#{video_id}"

    click_button "Next"
    click_button "Save"

    within(".demo_video_link.complete") do
      expect(page).not_to have_link("Add your project's description")

      expect(page).to have_css "[data-modal-fetch*='piece=demo']"
      expect(page).to have_link(
        "Change the technical video link",
        href: edit_mentor_team_submission_path(
          submission,
          piece: :demo_video_link
        )
      )
    end
  end

  scenario "Doesn't allow the same video link for the demo/technical video and pitch video" do
    click_link "Pitch"

    within(".demo_video_link.incomplete") do
      click_link "Add the technical video link"
    end

    video_id = "XMzMyNzg3OTY1Mg"
    fill_in "Youtube, Vimeo, or Youku URL",
      with: "https://v.youku.com/v_show/id_#{video_id}"

    click_button "Next"
    click_button "Save"

    within(".demo_video_link.complete") do
      expect(page).not_to have_link("Add your project's description")

      expect(page).to have_css "[data-modal-fetch*='piece=demo']"
      expect(page).to have_link(
        "Change the technical video link",
        href: edit_mentor_team_submission_path(
          submission,
          piece: :demo_video_link
        )
      )
    end

    within(".pitch_video_link.incomplete") do
      click_link "Add the pitch video link"
    end

    duplicate_video_id = "XMzMyNzg3OTY1Mg"
    fill_in "Youtube, Vimeo, or Youku URL",
      with: "https://v.youku.com/v_show/id_#{duplicate_video_id}"

    click_button "Next"
    click_button "Save"

    expect(page).to have_css(".flash.flash--alert", text: "Technical and pitch videos are the same link. Please update one of the links.")
  end

  scenario "Upload a .pdf business plan" do
    click_link "Entrepreneurship"

    within(".business_plan.incomplete") do
      click_link "Upload your team's plan"
    end

    attach_file(
      "Upload your team's plan",
      Rails.root + "spec/support/fixtures/business_plan.pdf"
    )

    click_button "Upload"

    within(".business_plan.complete") do
      expect(page).not_to have_link("Upload your team's plan")

      expect(page).to have_link(
        "business_plan.pdf",
        href: submission.reload.business_plan_url
      )
      expect(page).to have_link(
        "Change your upload",
        href: edit_mentor_team_submission_path(
          submission,
          piece: :business_plan
        )
      )
    end
  end
end
