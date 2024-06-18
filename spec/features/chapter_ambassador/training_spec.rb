require "rails_helper"

RSpec.feature "Chapter Ambassador Training" do
  scenario "Visiting the training completions endpoint marks training as complete and displays a thank you message" do
    chapter_ambassador = FactoryBot.create(:chapter_ambassador)

    sign_in(chapter_ambassador)
    visit chapter_ambassador_training_completion_path

    expect(chapter_ambassador.training_completed?).to eq(true)
    expect(page).to have_text("Thank you for completing the checkpoint!")
  end

  scenario "Visiting the training endpoint when training hasn't been completed displays a link to take the training" do
    chapter_ambassador = FactoryBot.create(:chapter_ambassador, training_completed_at: nil)

    sign_in(chapter_ambassador)
    visit chapter_ambassador_training_path

    expect(page).to have_text("Click the link below to proceed to the training checkpoint.")
    expect(page).to have_link("Training Checkpoint", href: external_chapter_ambassador_training_checkpoint_link(chapter_ambassador.account))
  end
end
