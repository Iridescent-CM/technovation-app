require "rails_helper"

RSpec.describe "A mentor completing their training", :js do
  it "displays their training step as complete" do
    sign_in(:mentor)
    expect(page).to have_xpath(
      '//*[@id="mentor_training"]/button/img[contains(@src, "circle-o")]'
    )

    visit mentor_training_completion_path
    click_button "Build your team"
    expect(page).to have_xpath(
      '//*[@id="mentor_training"]/button/img[contains(@src, "check-circle")]'
    )
  end

  it "is not required before the ImportantDates.mentor_training_required_since date" do
    Timecop.freeze(ImportantDates.mentor_training_required_since - 1.day) do
      sign_up(:mentor)
      click_button "Mentor training"
      expect(page).to have_content(
        "Training is not required because it was not available when you signed up. " +
        "However, we encourage you to complete the training to help you do your best!"
      )
      expect(page).to have_link(
        "Take the training now",
        href: ENV.fetch("MENTOR_TRAINING_URL")
      )
    end
  end

  it "is required on and after the ImportantDates.mentor_training_required_since date" do
    Timecop.freeze(ImportantDates.mentor_training_required_since) do
      sign_up(:mentor)
      click_button "Mentor training"
      expect(page).to have_content("Training is required.")
      expect(page).to have_link(
        "Take the training now",
        href: ENV.fetch("MENTOR_TRAINING_URL")
      )
    end
  end

  it "is required for returning mentors on and after the ImportantDates.mentor_training_required_since date" do
    mentor = FactoryBot.create(:mentor, :past)

    Timecop.freeze(ImportantDates.mentor_training_required_since) do
      sign_in(mentor)
      click_button "Mentor training"
      expect(page).to have_content("Training is required.")
      expect(page).to have_link(
        "Take the training now",
        href: ENV.fetch("MENTOR_TRAINING_URL")
      )
    end
  end
end