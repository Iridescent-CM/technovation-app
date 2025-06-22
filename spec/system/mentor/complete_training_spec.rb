require "rails_helper"

RSpec.describe "A mentor completing their training", :js do
  it "displays their training step as complete" do
    sign_in(:mentor)
    within("a[href='/mentor/training']") do
      expect(page).to have_css("span.bg-white")
    end

    visit mentor_training_completion_path
    click_link "Build your Team"
    within("a[href='/mentor/training']") do
      expect(page).to have_css("span.bg-tg-green")
    end
  end

  it "is not required for returning mentors before the ImportantDates.mentor_training_required_since date" do
    Timecop.freeze(ImportantDates.mentor_training_required_since - 1.day) do
      mentor = FactoryBot.create(:mentor)

      mentor.chapterable_assignments.create(
        account: mentor.account,
        chapterable: FactoryBot.create(:chapter),
        season: (ImportantDates.mentor_training_required_since - 1.day).year
      )

      sign_in(mentor)

      click_link "Mentor Training"
      expect(page).to have_content(
        "Training is not required because it was not available when you signed up. " +
        "However, we encourage you to complete the training to help you do your best!"
      )

      expect(page).not_to have_css("button.disabled", text: "Find your team")
      expect(page).not_to have_css("button.disabled", text: "Create your team")

      click_link "Submit your Project"
      expect(page).not_to have_content("You must complete the mentor training")
    end
  end

  it "is required for returning mentors on and after the ImportantDates.mentor_training_required_since date" do
    Timecop.freeze(ImportantDates.mentor_training_required_since) do
      mentor = FactoryBot.create(:mentor)

      mentor.chapterable_assignments.create(
        account: mentor.account,
        chapterable: FactoryBot.create(:chapter),
        season: ImportantDates.mentor_training_required_since.year
      )

      mentor.update_column(:training_completed_at, nil)
      sign_in(mentor)

      click_link "Mentor Training"
      expect(page).to have_content("To be able to mentor this season, please complete the mentor training.")

      click_link "Build your Team"
      expect(page).to have_content("You must complete the mentor training")

      expect(page).not_to have_button("Find team")

      click_link "Submit your Project"
      expect(page).to have_content("You need to complete some steps before going there")
    end
  end
end
