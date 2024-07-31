require "rails_helper"

RSpec.describe MentorProfileMentorType do
  let!(:mentor_profile) { FactoryBot.create(:mentor) }
  let!(:mentor_type) { FactoryBot.create(:mentor_type) }

  context "callbacks" do
    describe "#after_commit" do
      it "calls the job to update the mentor's program info in the CRM" do
        expect(CRM::UpdateProgramInfoJob).to receive(:perform_later)

        MentorProfileMentorType.create(
          mentor_profile_id: mentor_profile.id,
          mentor_type_id: mentor_type.id
        )
      end
    end
  end
end
