require "rails_helper"

RSpec.describe ChapterableAccountAssignment do
  describe "validations" do
    let(:abc_chapter) { FactoryBot.create(:chapter, name: "ABC Chapter") }

    describe "ensuring only one primary chapterable assignment exists per profile type per season" do
      context "as a student" do
        let(:student) { FactoryBot.create(:student) }

        context "when trying to create another primary assignment for the student for the same season" do
          let(:chapter_assignment_result) do
            student.chapterable_assignments.create(
              account: student.account,
              chapterable: abc_chapter,
              season: Season.current.year,
              primary: true
            )
          end

          it "does not create the assignment and includes an error message" do
            expect(student.chapterable_assignments.length).to eq(1)

            expect(chapter_assignment_result.errors[:base]).to include("This participant is already assigned to a chapter or club")
          end
        end

        context "when trying to create a primary assignment for the student for another season" do
          before do
            student.chapterable_assignments.create(
              account: student.account,
              chapterable: abc_chapter,
              season: Season.current.year + 1,
              primary: true
            )
          end

          it "successfully creates the assignment" do
            expect(student.chapterable_assignments.length).to eq(2)
          end
        end
      end

      context "as a mentor" do
        let(:mentor) { FactoryBot.create(:mentor) }

        context "when trying to create another primary assignment for the mentor for the same season" do
          let(:chapter_assignment_result) do
            mentor.chapterable_assignments.create(
              account: mentor.account,
              chapterable: abc_chapter,
              season: Season.current.year,
              primary: true
            )
          end

          it "does not create the assignment and includes an error message" do
            expect(mentor.chapterable_assignments.length).to eq(1)

            expect(chapter_assignment_result.errors[:base]).to include("This participant is already assigned to a chapter or club")
          end
        end

        context "when trying to create a non-primary assignment for the mentor for the same season" do
          before do
            mentor.chapterable_assignments.create(
              account: mentor.account,
              chapterable: abc_chapter,
              season: Season.current.year,
              primary: false
            )
          end

          it "successfully creates the assignment" do
            expect(mentor.chapterable_assignments.length).to eq(2)
          end
        end

        context "when a non-primary assignment already exists for the mentor" do
          before do
            mentor.chapterable_assignments.first.update_column(:primary, false)
          end

          context "when trying to create a primary assignment for the mentor (and a non-primary assignment already exits)" do
            before do
              mentor.chapterable_assignments.create!(
                account: mentor.account,
                chapterable: abc_chapter,
                season: Season.current.year,
                primary: true
              )
            end

            it "successfully creates the assignment" do
              expect(mentor.chapterable_assignments.length).to eq(2)
            end
          end
        end

        context "when trying to create a primary assignment for the mentor for another season" do
          before do
            mentor.chapterable_assignments.create(
              account: mentor.account,
              chapterable: abc_chapter,
              season: Season.current.year + 1,
              primary: true
            )
          end

          it "successfully creates the assignment" do
            expect(mentor.chapterable_assignments.length).to eq(2)
          end
        end
      end

      context "as a chapter ambassador" do
        let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }

        context "when trying to create another primary assignment for the chapter ambassador for the same season" do
          let(:chapter_assignment_result) do
            chapter_ambassador.chapterable_assignments.create(
              account: chapter_ambassador.account,
              chapterable: abc_chapter,
              season: Season.current.year,
              primary: true
            )
          end

          it "does not create the assignment and includes an error message" do
            expect(chapter_ambassador.chapterable_assignments.length).to eq(1)

            expect(chapter_assignment_result.errors[:base]).to include("This participant is already assigned to a chapter or club")
          end
        end

        context "when trying to create a primary assignment for the chapter ambassador for another season" do
          before do
            chapter_ambassador.chapterable_assignments.create(
              account: chapter_ambassador.account,
              chapterable: abc_chapter,
              season: Season.current.year + 1,
              primary: true
            )
          end

          it "successfully creates the assignment" do
            expect(chapter_ambassador.chapterable_assignments.length).to eq(2)
          end
        end
      end
    end
  end
end
