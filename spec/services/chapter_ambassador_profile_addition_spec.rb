require "rails_helper"

describe ChapterAmbassadorProfileAddition do
  let(:chapter_ambassador_profile_addition) {
    ChapterAmbassadorProfileAddition.new(account: account)
  }
  let(:account) do
    double(Account,
      id: 500,
      name: "Felonius Gru",
      mentor_profile: mentor_profile)
  end
  let(:mentor_profile) do
    instance_double(MentorProfile,
      school_company_name: "Anti-Villain League",
      job_title: "Agent",
      bio: "Strong, athletic, capable of dodging and leaping off heat-seeking missiles.")
  end

  before do
    allow(account).to receive(:create_chapter_ambassador_profile!)
  end

  it "calls the job that will setup the new chapter ambassador profile in the CRM" do
    expect(CRM::SetupAccountForCurrentSeasonJob).to receive(:perform_later)
      .with(
        account_id: account.id,
        profile_type: "chapter ambassador"
      )

    chapter_ambassador_profile_addition.call
  end
end
