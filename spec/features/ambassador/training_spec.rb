require "rails_helper"

RSpec.feature "Ambassador Training" do
  %w[chapter_ambassador club_ambassador].each do |scope|
    let(:profile) { FactoryBot.create(scope, :training_not_completed) }
    let(:current_scope) { scope }

    before do
      sign_in(profile)
    end

    scenario "Visiting the training completions endpoint marks training as complete and displays a thank you message" do
      visit public_send("#{scope}_training_completion_path")
      expect(profile.reload.training_completed?).to eq(true)
      expect(page).to have_text("Thank you for completing the checkpoint!")
    end

    scenario "Visiting the training endpoint when training hasn't been completed displays a link to take the training" do
      visit public_send("#{scope}_training_path")
      expect(page).to have_text("Please take the checkpoint to complete this step of onboarding.")
      expect(page).to have_link("Training Checkpoint", href: external_ambassador_training_checkpoint_link(profile.account))
    end
  end
end
