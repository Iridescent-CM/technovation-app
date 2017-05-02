require "rails_helper"

RSpec.describe TechnicalChecklist do
  it "should be completed" do
    team = FactoryGirl.create(:team)

    sub = TeamSubmission.create!({
      integrity_affirmed: true,
      team: team
    })

    2.times { sub.screenshots.create! }

    checklist = FactoryGirl.create(:technical_checklist,
                                   :completed,
                                   team_submission: sub)

    expect(checklist.completed?).to be true
  end
end
