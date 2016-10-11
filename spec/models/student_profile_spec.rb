require "rails_helper"

RSpec.describe StudentProfile do
  it "doesn't allow a student email to be used as parent email" do
    FactoryGirl.create(:student, email: "noway@jose.com")
    profile = FactoryGirl.build(:student_profile, parent_guardian_email: "noway@jose.com")
    expect(profile).not_to be_valid
    expect(profile.errors[:parent_guardian_email]).to include("cannot match another student's email")
  end

  it "re-sends the parental consent on update of parent email" do
    FactoryGirl.create(:student_profile)
               .update_attributes(parent_guardian_email: "something@else.com")

    mail = ActionMailer::Base.deliveries.last
    expect(mail).to be_present, "no email sent"
    expect(mail.to).to eq(["something@else.com"])
    expect(mail.subject).to include("Your daughter")
  end

  it "voids the original parental consent on update of parent email" do
    profile = FactoryGirl.create(:student_profile)
    consent = profile.reload.student_account.create_parental_consent(FactoryGirl.attributes_for(:parental_consent))

    profile.update_attributes(parent_guardian_email: "something@else.com")

    expect(consent).to be_voided
  end

  it "re-subscribes new email addresses" do
    profile = FactoryGirl.create(:student_profile)

    expect(UpdateEmailListJob).to receive(:perform_later)
      .with(profile.parent_guardian_email, "new@parent-email.com",
            profile.parent_guardian_name, "PARENT_LIST_ID")

    profile.update_attributes(parent_guardian_email: "new@parent-email.com")
  end
end
