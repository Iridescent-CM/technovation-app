require "rails_helper"

RSpec.describe JoinRequest do
  it "deletes other student requests upon acceptance" do
    student = FactoryGirl.create(:student)
    approve_me = FactoryGirl.create(:join_request, requestor: student)
    delete_me = FactoryGirl.create(:join_request, requestor: student)

    JoinRequestApproved.(approve_me)

    expect {
      delete_me.reload
    }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "does not mess with pending mentor join requests on approval" do
    mentor = FactoryGirl.create(:mentor)
    approve_me = FactoryGirl.create(:join_request, requestor: mentor)
    still_pending = FactoryGirl.create(:join_request, requestor: mentor)

    JoinRequestApproved.(approve_me)

    expect(still_pending.reload).to be_pending
  end
end
