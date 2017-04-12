require "rails_helper"

RSpec.describe TechnicalChecklist do
  it "should be completed" do
    team = FactoryGirl.create(:team)
    sub = TeamSubmission.create!({
      integrity_affirmed: true,
      team: team
    })
    2.times {
      s = Screenshot.create!()
      s.update_column(:image, "/img/screenshot.png")
      sub.screenshots << s
    }
    checklist = FactoryGirl.create(:technical_checklist, :completed)
    sub.technical_checklist = checklist
    expect(checklist.completed?).to be true
  end
end