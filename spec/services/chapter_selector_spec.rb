require "rails_helper"

describe ChapterSelector do
  let(:chapter_selector) { ChapterSelector.new(account: account) }
  let(:account) { FactoryBot.create(:account, :los_angeles) }

  describe "#call" do
    context "when there is a chapter in the same state/province" do
      let(:las_angeles_chapter) { FactoryBot.create(:chapter, :los_angeles) }

      it "returns the chapter in the same state/province" do
        expect(chapter_selector.call).to eq([las_angeles_chapter])
      end
    end

    context "when there are no chapters in the same state/province" do
      before do
        Chapter.delete_all
      end

      context "when there is a chapter in the same country" do
        let(:chicago_chapter) { FactoryBot.create(:chapter, :chicago) }

        it "returns the chapter in the same country" do
          expect(chapter_selector.call).to eq([chicago_chapter])
        end
      end
    end

    context "when there are no chapters in the same state/province or country" do
      before do
        Chapter.delete_all
      end

      it "returns an empty array" do
        expect(chapter_selector.call).to eq([])
      end
    end
  end
end
