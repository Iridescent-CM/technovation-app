require "rails_helper"

RSpec.describe StudentProfile do
  it "validates the parent/guardian email" do
    %w{bad bad@ something.bad.org not@okay}.each do |bad_email|
      profile = FactoryGirl.build(:student_profile, parent_guardian_email: bad_email)
      expect(profile).not_to be_valid
      expect(profile.errors[:parent_guardian_email]).not_to be_nil
    end
  end

  it "re-sends the parental consent on update of parent email" do
    FactoryGirl.create(:student_profile)
               .update_attributes(parent_guardian_email: "something@else.com")

    mail = ActionMailer::Base.deliveries.last
    expect(mail).to be_present, "no email sent"
    expect(mail.to).to eq(["something@else.com"])
    expect(mail.subject).to eq("Your daughter needs consent to participate in the Technovation Challenge!")
  end

  it "voids the original parental consent on update of parent email" do
    profile = FactoryGirl.create(:student_profile)
    consent = profile.reload.student_account.create_parental_consent(FactoryGirl.attributes_for(:parental_consent))

    profile.update_attributes(parent_guardian_email: "something@else.com")

    expect(consent).to be_voided
  end
end
