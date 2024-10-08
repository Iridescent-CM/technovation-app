require "rails_helper"

RSpec.describe "Admins assigning people to chapters" do
  describe "assigning a student to a chapter" do
    let(:student) { FactoryBot.create(:student) }
    let!(:chapter) { FactoryBot.create(:chapter) }

    before do
      sign_in(:admin)
    end

    it "assigns the selected chapter to the student" do
      visit admin_participant_path(student.account)

      click_link "Edit chapter"

      select chapter.organization_name
      click_button "Save"

      expect(student.account.current_chapter).to eq(chapter)
    end

    context "when a student is already assigned to a chapter" do
      before do
        student.chapter_assignments.create(
          account: student.account,
          chapter: FactoryBot.create(:chapter),
          season: Season.current.year
        )
      end

      it "reassigns the student to a newly selected chapter" do
        new_chapter = FactoryBot.create(:chapter, organization_name: "Atarashi chapter")

        visit admin_participant_path(student.account)

        click_link "Edit chapter"

        select new_chapter.organization_name
        click_button "Save"

        expect(student.account.current_chapter).to eq(new_chapter)
      end
    end
  end

  describe "assigning a chapter ambassador to a chapter" do
    let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }
    let!(:chapter) { FactoryBot.create(:chapter) }

    before do
      sign_in(:admin)
    end

    it "assigns the selected chapter to the chapter ambassador" do
      visit admin_participant_path(chapter_ambassador.account)

      click_link "Edit chapter"

      select chapter.organization_name
      click_button "Save"

      expect(chapter_ambassador.account.current_chapter).to eq(chapter)
    end

    context "when a chapter ambassador is already assigned to a chapter" do
      before do
        chapter_ambassador.chapter_assignments.create(
          account: chapter_ambassador.account,
          chapter: FactoryBot.create(:chapter),
          season: Season.current.year
        )
      end

      it "reassigns the chapter ambassador to a newly selected chapter" do
        new_chapter = FactoryBot.create(:chapter, organization_name: "Atarashi chapter")

        visit admin_participant_path(chapter_ambassador.account)

        click_link "Edit chapter"

        select new_chapter.organization_name
        click_button "Save"

        expect(chapter_ambassador.account.current_chapter).to eq(new_chapter)
      end
    end
  end
end
