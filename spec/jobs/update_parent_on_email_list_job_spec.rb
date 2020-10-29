require "rails_helper"

RSpec.describe UpdateParentOnEmailListJob do
  let(:student_profile) do
    double(StudentProfile,
      id: 1,
      parent_guardian_name: "Witch Wizard",
      parent_guardian_email: "witch@example.com")
  end
  let(:faux_parent_account) do
    double(FauxAccount,
      full_name: student_profile.parent_guardian_name,
      email: student_profile.parent_guardian_email)
  end
  let(:currently_subscribed_as) { student_profile.parent_guardian_email }

  before do
    allow(StudentProfile).to receive(:find).with(student_profile.id).and_return(student_profile)
    allow(FauxAccount).to receive(:new)
      .with(methods_with_return_values: {
        full_name: student_profile.parent_guardian_name,
        email: student_profile.parent_guardian_email
      })
      .and_return(faux_parent_account)
    allow(Mailchimp::MailingList).to receive_message_chain(:new, :update)
  end

  it "creates a faux parent account for the Mailchimp service to use" do
    expect(FauxAccount).to receive(:new)
      .with(methods_with_return_values: {
        full_name: student_profile.parent_guardian_name,
        email: student_profile.parent_guardian_email
      })
      .and_return(faux_parent_account)

    UpdateParentOnEmailListJob.perform_now(
      student_profile_id: student_profile.id,
      currently_subscribed_as: currently_subscribed_as
    )
  end

  it "calls the Mailchimp service that will subscribe the parent" do
    expect(Mailchimp::MailingList).to receive_message_chain(:new, :update)
      .with(account: faux_parent_account, currently_subscribed_as: currently_subscribed_as)

    UpdateParentOnEmailListJob.perform_now(
      student_profile_id: student_profile.id,
      currently_subscribed_as: currently_subscribed_as
    )
  end
end
