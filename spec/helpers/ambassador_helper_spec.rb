require "rails_helper"

RSpec.describe AmbassadorHelper do
  let(:chapter_ambassador) do
    FactoryBot.create(
      :chapter_ambassador,
      :not_assigned_to_chapter,
      national_view: national_view
    )
  end
  let(:national_view) { false }
  let(:brazil_chapter) do
    FactoryBot.create(
      :chapter,
      :brazil,
      primary_contact: chapter_ambassador.account
    )
  end

  before do
    chapter_ambassador.chapterable_assignments.create(
      chapterable: brazil_chapter,
      account: chapter_ambassador.account,
      season: Season.current.year,
      primary: true
    )
  end

  describe "#ambassador_can_view_participant_details?" do
    context "when a chapter ambassador has the national view ability" do
      let(:national_view) { true }

      context "when a chapter ambassador is trying to view a student in their region" do
        let(:student_in_region) { FactoryBot.create(:student, :brazil) }

        it "returns true" do
          expect(ambassador_can_view_participant_details?(ambassador: chapter_ambassador, participant_profile: student_in_region)).to eq(true)
        end
      end

      context "when a chapter ambassador is trying to view a student in another region" do
        let(:student_in_another_region) { FactoryBot.create(:student, :chicago) }

        it "returns false" do
          expect(ambassador_can_view_participant_details?(ambassador: chapter_ambassador, participant_profile: student_in_another_region)).to eq(false)
        end
      end

      context "when a chapter ambassador is trying to view a mentor in their region" do
        let(:mentor_in_region) { FactoryBot.create(:mentor, :brazil) }

        it "returns true" do
          expect(ambassador_can_view_participant_details?(ambassador: chapter_ambassador, participant_profile: mentor_in_region)).to eq(true)
        end
      end

      context "when a chapter ambassador is trying to view a mentor in another region" do
        let(:mentor_in_another_region) { FactoryBot.create(:mentor, :chicago) }

        it "returns true" do
          expect(ambassador_can_view_participant_details?(ambassador: chapter_ambassador, participant_profile: mentor_in_another_region)).to eq(true)
        end
      end
    end

    context "when a chapter ambassador does not have the national view ability" do
      let(:national_view) { false }

      context "when a chapter ambassador is trying to view a student that belongs to their chapter" do
        let(:student_assigned_to_same_chapter) { FactoryBot.create(:student, :not_assigned_to_chapter) }

        before do
          student_assigned_to_same_chapter.chapterable_assignments.create(
            account: student_assigned_to_same_chapter.account,
            chapterable: brazil_chapter,
            season: Season.current.year,
            primary: true
          )
        end

        it "returns true" do
          expect(ambassador_can_view_participant_details?(ambassador: chapter_ambassador, participant_profile: student_assigned_to_same_chapter)).to eq(true)
        end
      end

      context "when a chapter ambassador is trying to view a student that belongs to another chapter" do
        let(:student_assigned_to_another_chapter) { FactoryBot.create(:student, :not_assigned_to_chapter) }

        before do
          student_assigned_to_another_chapter.chapterable_assignments.create(
            account: student_assigned_to_another_chapter.account,
            chapterable: FactoryBot.create(:chapter, :chicago),
            season: Season.current.year,
            primary: true
          )
        end

        it "returns false" do
          expect(ambassador_can_view_participant_details?(ambassador: chapter_ambassador, participant_profile: student_assigned_to_another_chapter)).to eq(false)
        end
      end

      context "when a chapter ambassador is trying to view a mentor that belongs to their chapter" do
        let(:mentor_assigned_to_same_chapter) { FactoryBot.create(:mentor, :not_assigned_to_chapter) }

        before do
          mentor_assigned_to_same_chapter.chapterable_assignments.create(
            account: mentor_assigned_to_same_chapter.account,
            chapterable: brazil_chapter,
            season: Season.current.year,
            primary: true
          )
        end

        it "returns true" do
          expect(ambassador_can_view_participant_details?(ambassador: chapter_ambassador, participant_profile: mentor_assigned_to_same_chapter)).to eq(true)
        end
      end

      context "when a chapter ambassador is trying to view a mentor that belongs to another chapter" do
        let(:mentor_assigned_to_another_chapter) { FactoryBot.create(:mentor, :not_assigned_to_chapter) }

        before do
          mentor_assigned_to_another_chapter.chapterable_assignments.create(
            account: mentor_assigned_to_another_chapter.account,
            chapterable: FactoryBot.create(:chapter, :chicago),
            season: Season.current.year,
            primary: true
          )
        end

        it "returns true" do
          expect(ambassador_can_view_participant_details?(ambassador: chapter_ambassador, participant_profile: mentor_assigned_to_another_chapter)).to eq(true)
        end
      end
    end
  end

  describe "#ambassador_can_view_team_details?" do
    context "when a chapter ambassador has the national view ability" do
      let(:national_view) { true }

      context "when a chapter ambassador is trying to view a team in their region" do
        let(:team_in_region) { FactoryBot.create(:team, :brazil) }

        it "returns true" do
          expect(ambassador_can_view_team_details?(ambassador: chapter_ambassador, team: team_in_region)).to eq(true)
        end
      end

      context "when a chapter ambassador is trying to view a team in another region" do
        let(:team_in_another_region) { FactoryBot.create(:team, :chicago) }

        it "returns false" do
          expect(ambassador_can_view_team_details?(ambassador: chapter_ambassador, team: team_in_another_region)).to eq(false)
        end
      end
    end

    context "when a chapter ambassador does not have the national view ability" do
      let(:national_view) { false }

      context "when a chapter ambassador is trying to view a team from a student that belongs to their chapter" do
        let(:student_assigned_to_same_chapter) { FactoryBot.create(:student, :not_assigned_to_chapter) }
        let(:team) { FactoryBot.create(:team) }

        before do
          student_assigned_to_same_chapter.chapterable_assignments.create(
            account: student_assigned_to_same_chapter.account,
            chapterable: brazil_chapter,
            season: Season.current.year,
            primary: true
          )

          TeamRosterManaging.add(team, student_assigned_to_same_chapter)
        end

        it "returns true" do
          expect(ambassador_can_view_team_details?(ambassador: chapter_ambassador, team: team)).to eq(true)
        end
      end

      context "when a chapter ambassador is trying to view a team from a student that belongs to another chapter" do
        let(:student_assigned_to_another_chapter) { FactoryBot.create(:student, :not_assigned_to_chapter) }
        let(:team) { FactoryBot.create(:team) }

        before do
          student_assigned_to_another_chapter.chapterable_assignments.create(
            account: student_assigned_to_another_chapter.account,
            chapterable: FactoryBot.create(:chapter, :chicago),
            season: Season.current.year,
            primary: true
          )

          TeamRosterManaging.add(team, student_assigned_to_another_chapter)
        end

        it "returns false" do
          expect(ambassador_can_view_team_details?(ambassador: chapter_ambassador, team: team)).to eq(false)
        end
      end
    end
  end
end
