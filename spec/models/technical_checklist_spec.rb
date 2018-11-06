require "rails_helper"

RSpec.describe TechnicalChecklist do
  it "should be completed" do
    team = FactoryBot.create(:team)

    sub = TeamSubmission.create!({
      integrity_affirmed: true,
      team: team
    })

    2.times { sub.screenshots.create! }

    checklist = FactoryBot.create(:technical_checklist,
                                   :completed,
                                   team_submission: sub)

    expect(checklist).to be_completed
  end
end
