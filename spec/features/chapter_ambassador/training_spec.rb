require "rails_helper"

RSpec.feature "Chapter Ambassador can complete training checkpoint" do
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }

  before do
    sign_in(chapter_ambassador)
  end

  scenario "Chapter ambassador has completed training" do
    visit chapter_ambassador_training_completion_path
    expect(page).to have_text("Thank you for completing the checkpoint!")
  end

  scenario "Chapter ambassador has not completed training" do
    visit chapter_ambassador_training_path

    expect(page).to have_text("Click the link below to proceed to the training checkpoint.")
    expect(page).to have_link("Training Checkpoint", href: chapter_ambassador_training_checkpoint_link(chapter_ambassador.account))
  end
end
