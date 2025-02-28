require "rails_helper"

RSpec.feature "chapter ambassadors viewing participants" do
  let(:chapter_ambassador) do
    FactoryBot.create(
      :chapter_ambassador,
      :not_assigned_to_chapter,
      national_view: national_view
    )
  end
  let(:brazil_chapter) { FactoryBot.create(:chapter, :brazil, :onboarded) }
  let!(:brazil_student_in_same_chapter) { FactoryBot.create(:student, :brazil, :not_assigned_to_chapter) }
  let!(:brazil_student_in_another_chapter) { FactoryBot.create(:student, :brazil) }
  let!(:unaffiliated_brazil_student_in_another_chapter) { FactoryBot.create(:student, :brazil, :not_assigned_to_chapter) }
  let(:national_view) { false }

  before do
    chapter_ambassador.chapterable_assignments.create(
      account: chapter_ambassador.account,
      chapterable: brazil_chapter,
      season: Season.current.year,
      primary: true
    )

    brazil_student_in_same_chapter.chapterable_assignments.create(
      account: brazil_student_in_same_chapter.account,
      chapterable: brazil_chapter,
      season: Season.current.year,
      primary: true
    )

    sign_in(chapter_ambassador)
  end

  context "when a chapter ambassador has the 'national view' ability" do
    let(:national_view) { true }

    context "when viewing the participants datagrid" do
      before do
        visit(chapter_ambassador_participants_path)
      end

      scenario "displays all participants in the chapter's region (including participants in the same and different chapters and unaffilated participants)" do
        expect(page).to have_content(brazil_student_in_same_chapter.account.email)
        expect(page).to have_content(brazil_student_in_another_chapter.account.email)
        expect(page).to have_content(unaffiliated_brazil_student_in_another_chapter.account.email)
      end
    end
  end

  context "when a chapter ambassador does not have the 'national view' ability" do
    let(:national_view) { false }

    context "when viewing the participants datagrid" do
      before do
        visit(chapter_ambassador_participants_path)
      end

      scenario "only displays participants assigned to ChA's chapter (and doesn't include participants belonging to another chapter or unaffilated participants)" do
        expect(page).to have_content(brazil_student_in_same_chapter.account.email)
        expect(page).not_to have_content(brazil_student_in_another_chapter.account.email)
        expect(page).not_to have_content(unaffiliated_brazil_student_in_another_chapter.account.email)
      end
    end
  end
end
