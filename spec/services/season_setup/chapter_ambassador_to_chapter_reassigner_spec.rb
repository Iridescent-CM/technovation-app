require "rails_helper"

describe SeasonSetup::ChapterAmbassadorToChapterReassigner do
  let(:chapter_ambassador_to_chapter_reassigner) { SeasonSetup::ChapterAmbassadorToChapterReassigner.new }
  let(:chapter_ambassador_profile) { FactoryBot.create(:chapter_ambassador) }
  let(:account) { chapter_ambassador_profile.account }

  before do
    account.chapterable_assignments.delete_all
  end

  describe "#call" do
    context "when the chapter ambassador is assigned to a primary chapter for the previous season" do
      let(:last_season) { Season.current.year - 1 }
      let(:chapter) { FactoryBot.create(:chapter) }

      before do
        account.chapterable_assignments.create(
          profile: chapter_ambassador_profile,
          chapterable: chapter,
          season: last_season,
          primary: true
        )
      end

      context "when the chapter is active for the current season" do
        let(:current_season) { Season.current.year }

        before do
          chapter.update(seasons: [current_season])
        end

        it "reassigns the chapter ambassador to the chapter" do
          chapter_ambassador_to_chapter_reassigner.call

          expect(account.reload.current_chapterable_assignment.chapterable).to eq(chapter)
          expect(account.reload.current_chapterable_assignments.length).to eq(1)
        end
      end

      context "when the chapter is not active for the current season" do
        before do
          chapter.update(seasons: [last_season])
        end

        it "does not make a new chapterable assignment" do
          chapter_ambassador_to_chapter_reassigner.call

          expect(account.current_chapterable_assignments.length).to eq(0)
          expect(account.last_seasons_chapterable_assignments.length).to eq(1)
        end
      end
    end

    context "when the chapter ambassador is already assigned to a chapter for the current season" do
      let(:current_season) { Season.current.year }

      before do
        account.chapterable_assignments.create(
          profile: chapter_ambassador_profile,
          chapterable: FactoryBot.create(:chapter),
          season: current_season
        )
      end

      it "does not make a new chapterable assignment" do
        chapter_ambassador_to_chapter_reassigner.call

        expect(account.current_chapterable_assignments.length).to eq(1)
      end
    end
  end
end
