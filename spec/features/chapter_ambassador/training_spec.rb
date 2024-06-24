require "rails_helper"

RSpec.feature "Chapter Ambassador Training" do
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador, :training_not_completed) }

  before do
    sign_in(chapter_ambassador)
  end

  scenario "Visiting the training completions endpoint marks training as complete and displays a thank you message" do
    visit chapter_ambassador_training_completion_path

    expect(chapter_ambassador.reload.training_completed?).to eq(true)
    expect(page).to have_text("Thank you for completing the checkpoint!")
  end

  scenario "Visiting the training endpoint when training hasn't been completed displays a link to take the training" do
    visit chapter_ambassador_trainings_path
    expect(page).to have_text("Please take the checkpoint to complete this step of onboarding.")
    expect(page).to have_link("Training Checkpoint", href: external_chapter_ambassador_training_checkpoint_link(chapter_ambassador.account))
  end

  scenario "Visiting the training endpoint when training hasn't been completed displays a link to view the training modal" do
    visit chapter_ambassador_trainings_path

    expect(page).to have_text("Please review the following training modules.")
    expect(page).to have_selector("a[href='#'][data-opens-modal='training-modal-1']", text: "Training Module 1: Program Overview")
  end
end
