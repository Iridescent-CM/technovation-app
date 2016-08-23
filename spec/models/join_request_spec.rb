require "rails_helper"

RSpec.describe JoinRequest do
  it "invalidates other student requests upon acceptance" do
    student = FactoryGirl.create(:student)
    approve_me = FactoryGirl.create(:join_request, requestor: student)
    reject_me = FactoryGirl.create(:join_request, requestor: student)

    approve_me.approved!

    expect(reject_me.reload).to be_rejected
  end

  it "does not mess with pending mentor join requests on approval" do
    mentor = FactoryGirl.create(:mentor)
    approve_me = FactoryGirl.create(:join_request, requestor: mentor)
    still_pending = FactoryGirl.create(:join_request, requestor: mentor)

    approve_me.approved!

    expect(still_pending.reload).to be_pending
  end
end
