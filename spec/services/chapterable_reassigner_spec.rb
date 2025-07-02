require "rails_helper"

describe ChapterableReassigner do
  let(:chapterable_reassigner) { ChapterableReassigner.new(account: account) }

  describe "#call" do
    context "when it's a mentor" do
      let(:mentor_profile) { FactoryBot.create(:mentor) }
      let(:account) { mentor_profile.account }

      before do
        account.chapterable_assignments.delete_all
      end

      context "when the mentor is assigned to a primary chapterable for the previous season" do
        let(:last_season) { Season.current.year - 1 }
        let(:chapter) { FactoryBot.create(:chapter) }

        before do
          account.chapterable_assignments.create!(
            profile: mentor_profile,
            chapterable: chapter,
            season: last_season,
            primary: true
          )
        end

        it "makes a new chapterable assignment for the current season" do
          chapterable_reassigner.call

          expect(account.chapterable_assignments.length).to eq(2)
          expect(
            account.chapterable_assignments.last.season
          ).to eq(Season.current.year)
        end

        context "when the chapter is not active for the current season" do
          before do
            chapter.update(seasons: [last_season])
          end

          it "does not make a new chapterable assignment" do
            chapterable_reassigner.call

            expect(account.chapterable_assignments.length).to eq(1)
          end
        end
      end

      context "when the mentor is already assigned to a chapterable for the current season" do
        let(:current_season) { Season.current.year }

        before do
          account.chapterable_assignments.create(
            profile: mentor_profile,
            chapterable: FactoryBot.create(:chapter),
            season: current_season
          )
        end

        it "does not make a new chapterable assignment" do
          chapterable_reassigner.call

          expect(account.chapterable_assignments.length).to eq(1)
        end
      end
    end

    context "when it's a student" do
      let(:student_profile) { FactoryBot.create(:student) }
      let(:account) { student_profile.account }

      before do
        account.chapterable_assignments.delete_all
      end

      context "when the student is assigned to a primary chapterable for the previous season" do
        let(:last_season) { Season.current.year - 1 }
        let(:chapter) { FactoryBot.create(:chapter) }

        before do
          account.chapterable_assignments.create!(
            profile: student_profile,
            chapterable: chapter,
            season: last_season,
            primary: true
          )
        end

        it "makes a new chapterable assignment for the current season" do
          chapterable_reassigner.call

          expect(account.chapterable_assignments.length).to eq(2)
          expect(
            account.chapterable_assignments.last.season
          ).to eq(Season.current.year)
        end

        context "when the chapter is not active for the current season" do
          before do
            chapter.update(seasons: [last_season])
          end

          it "does not make a new chapterable assignment" do
            chapterable_reassigner.call

            expect(account.chapterable_assignments.length).to eq(1)
          end
        end
      end

      context "when the student is already assigned to a chapterable for the current season" do
        let(:current_season) { Season.current.year }

        before do
          account.chapterable_assignments.create(
            profile: student_profile,
            chapterable: FactoryBot.create(:chapter),
            season: current_season
          )
        end

        it "does not make a new chapterable assignment" do
          chapterable_reassigner.call

          expect(account.chapterable_assignments.length).to eq(1)
        end
      end
    end
  end
end
