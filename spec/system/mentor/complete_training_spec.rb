require "rails_helper"

RSpec.describe "A mentor completing their training", :js do
  it "displays their training step as complete" do
    sign_in(:mentor)
    expect(page).to have_xpath(
      '//*[@id="mentor_training"]/button/img[contains(@src, "circle-o")]'
    )

    visit mentor_training_completion_path
    click_button "Build your Team"
    expect(page).to have_xpath(
      '//*[@id="mentor_training"]/button/img[contains(@src, "check-circle")]'
    )
  end

  it "is not required for returning mentors before the ImportantDates.mentor_training_required_since date" do
    mentor = FactoryBot.create(:mentor, :past)
    mentor.update_column(:bio, "Something of sufficient length " * 10)
    mentor.create_consent_waiver!(electronic_signature: "me")
    mentor.create_background_check!(candidate_id: "TEST", report_id: "TEST", status: :clear)

    Timecop.freeze(ImportantDates.mentor_training_required_since - 1.day) do
      sign_in(:mentor)

      click_button "Mentor training"
      expect(page).to have_content(
        "Training is not required because it was not available when you signed up. " +
        "However, we encourage you to complete the training to help you do your best!"
      )

      expect(page).not_to have_css("button.disabled", text: "Find your team")
      expect(page).not_to have_css("button.disabled", text: "Create your team")

      click_button "Submit your Project"
      expect(page).not_to have_content("You must complete the mentor training")
    end
  end

  it "is required for returning mentors on and after the ImportantDates.mentor_training_required_since date" do
    mentor = nil

    Timecop.freeze(ImportantDates.registration_opens - 8.months) do
      mentor = FactoryBot.create(:mentor, :past)
    end

    Timecop.freeze(ImportantDates.mentor_training_required_since) do
      mentor.update_column(:training_completed_at, nil)
      sign_in(mentor)

      expect(page).to have_css("button.disabled", text: "Find your team")
      expect(page).to have_css("button.disabled", text: "Create your team")

      click_button "Submit your Project"
      expect(page).to have_content("not available")
      expect(page).to have_content("You must complete the mentor training")
    end
  end
end
