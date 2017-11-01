require "rails_helper"

RSpec.describe InviteRA do
  it "doesn't replace existing approved RAs" do
    ra = FactoryBot.create(:ambassador, :approved)

    account = FactoryBot.build(:account, email: ra.email)

    invited = InviteRA.(account.attributes)

    expect(invited).to be_nil
  end

  it "replaces any other type of account found" do
    %w{mentor student judge}.each do |scope|
      existing = FactoryBot.create(scope).account

      account = FactoryBot.build(:account, email: existing.email)

      invited = InviteRA.(
        account.attributes.merge(FactoryBot.attributes_for(:ambassador))
      )

      expect(invited).not_to be_nil

      expect {
        existing.reload
      }.to raise_error(ActiveRecord::RecordNotFound)

      expect(invited.account_id).not_to be_nil
      expect(invited.account_id).not_to eq(existing.id)
    end
  end

  it "re-assigns existing background checks" do
    mentor = FactoryBot.create(:mentor)
    mentor.background_check.update({
      report_id: "unique-for-this-test",
      candidate_id: "also-unique-for-this-test",
    })

    account = FactoryBot.build(:account, email: mentor.email)

    invited = InviteRA.(
      account.attributes.merge(FactoryBot.attributes_for(:ambassador))
    )

    bg_check = invited.account.background_check
    expect(bg_check.report_id).to eq("unique-for-this-test")
    expect(bg_check.candidate_id).to eq("also-unique-for-this-test")

    invited.account.create_mentor_profile!(FactoryBot.attributes_for(:mentor))
    expect(invited.account.mentor_profile).to be_background_check_complete
  end
end
