require "rails_helper"

describe ChapterSelector do
  let(:chapter_selector) { ChapterSelector.new(account: account) }
  let(:account) { FactoryBot.create(:account, :mentor, :los_angeles) }

  describe "#call" do
    context "when there is a chapter in the same state/province" do
      let!(:los_angeles_chapter) { FactoryBot.create(:chapter, :los_angeles) }

      it "returns the chapter in the same state/province" do
        expect(chapter_selector.call).to eq({
          chapters_in_state_province: [los_angeles_chapter],
          chapters_in_country: []
        })
      end

      context "when there is a chapter in the same country" do
        let!(:chicago_chapter) { FactoryBot.create(:chapter, :chicago) }

        it "returns the chapter in the same state/province and the one in the country" do
          expect(chapter_selector.call).to eq({
            chapters_in_state_province: [los_angeles_chapter],
            chapters_in_country: [chicago_chapter]
          })
        end

        context "when the los angeles chapter isn't participating in the current season" do
          before do
            los_angeles_chapter.update(seasons: [])
          end

          it "does not include the los angeles chapter in the results" do
            expect(chapter_selector.call).to eq({
              chapters_in_state_province: [],
              chapters_in_country: [chicago_chapter]
            })
          end
        end

        context "when the account already belongs to the los angeles chapter" do
          before do
            account.chapterable_assignments.delete_all

            account.chapterable_assignments.create(
              chapterable: los_angeles_chapter,
              profile: account.mentor_profile,
              season: Season.current.year,
              primary: true
            )
          end

          it "does not include the los angeles chapter in the results" do
            expect(chapter_selector.call).to eq({
              chapters_in_state_province: [],
              chapters_in_country: [chicago_chapter]
            })
          end
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
