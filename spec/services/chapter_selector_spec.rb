require "rails_helper"

describe ChapterSelector do
  let(:chapter_selector) { ChapterSelector.new(account: account) }
  let(:account) { FactoryBot.create(:account, :los_angeles) }

  describe "#call" do
    context "when there is a chapter in the same state/province" do
      let(:las_angeles_chapter) { FactoryBot.create(:chapter, :los_angeles) }

      it "returns the chapter in the same state/province" do
        expect(chapter_selector.call).to eq({
          chapters_in_state_province: [las_angeles_chapter],
          chapters_in_country: []
        })
      end

      context "when there is a chapter in the same country" do
        let(:chicago_chapter) { FactoryBot.create(:chapter, :chicago) }

        it "returns the chapter in the same state/province and the one in the country" do
          expect(chapter_selector.call).to eq({
            chapters_in_state_province: [las_angeles_chapter],
            chapters_in_country: [chicago_chapter]
          })
        end
      end
    end

    context "when there are no chapters in the same state/province or country" do
      before do
        Chapter.delete_all
      end

      it "returns an empty result" do
        expect(chapter_selector.call).to eq({
          chapters_in_state_province: [],
          chapters_in_country: []
        })
      end
    end
  end
end
