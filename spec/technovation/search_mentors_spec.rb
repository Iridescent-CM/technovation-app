require "rails_helper"

RSpec.describe SearchMentors do
  let(:searcher) { FactoryBot.create(:account) }
  let(:search_filter) do
    SearchFilter.new({
      nearby: "anywhere",
      coordinates: searcher.coordinates,
      female_only: female_only,
    })
  end
  let(:female_only) { "0" }
  let(:onboarded_mentor) { FactoryBot.create(:mentor, :onboarded) }

  it "returns an onboarded mentor" do
    expect(SearchMentors.(search_filter)).to include(onboarded_mentor)
  end

  context "gender identity filter" do
    let!(:male) { FactoryBot.create(:mentor, :onboarded, gender: "Male") }
    let!(:female) { FactoryBot.create(:mentor, :onboarded, gender: "Female") }
    let!(:non_binary) { FactoryBot.create(:mentor, :onboarded, gender: "Non-binary") }
    let!(:prefer_not_to_say) { FactoryBot.create(:mentor, :onboarded, gender: "Prefer not to say") }

    context "no preference" do
      let(:female_only) { "0" }

      it "finds all gender identities" do
        results = SearchMentors.(search_filter)
        expect(results).to include(male)
        expect(results).to include(female)
        expect(results).to include(non_binary)
        expect(results).to include(prefer_not_to_say)
      end
    end

    context "female only" do
      let(:female_only) { "1" }

      it "finds only female" do
        results = SearchMentors.(search_filter)
        expect(results).to include(female)
        expect(results).not_to include(male)
        expect(results).not_to include(non_binary)
        expect(results).not_to include(prefer_not_to_say)
      end
    end
  end
end