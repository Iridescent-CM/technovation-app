require "rails_helper"

RSpec.feature "Judge suspensions" do
  let(:admin) { FactoryBot.create(:admin) }
  let(:active_judge) { FactoryBot.create(:judge) }
  let(:suspended_judge) { FactoryBot.create(:judge, suspended: true) }

  scenario "Admin suspending a judge" do
    sign_in(admin)

    visit admin_participant_path(active_judge.account)

    expect(active_judge).not_to be_suspended

    click_link "Suspend this judge"

    expect(active_judge.reload).to be_suspended
    expect(current_path).to eq(admin_participant_path(active_judge.account))
    expect(page).to have_text("has been suspended")
  end

  scenario "Admin unsuspending a judge" do
    sign_in(admin)

    visit admin_participant_path(suspended_judge.account)

    expect(suspended_judge).to be_suspended

    click_link "Enable this judge"

    expect(suspended_judge.reload).not_to be_suspended
    expect(current_path).to eq(admin_participant_path(suspended_judge.account))
    expect(page).to have_text("no longer suspended")
  end
end
