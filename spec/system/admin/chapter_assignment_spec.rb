require "rails_helper"

RSpec.describe "Admins assigning participants to chapters" do
  describe "assigning a student to a chapter" do
    let(:student) { FactoryBot.create(:student) }
    let!(:chapter) { FactoryBot.create(:chapter) }

    before do
      sign_in(:admin)
    end

    context "when a student doesn't have a chapter assignment" do
      before do
        student.account.chapterable_assignments.delete_all
      end

      it "assigns the selected chapter to the student" do
        visit admin_participant_path(student.account)

        click_link "Assign to a chapter"

        select chapter.organization_name
        click_button "Save"

        expect(student.account.current_chapter).to eq(chapter)
      end
    end

    context "when a student is already assigned to a chapter" do
      before do
        student.account.chapterable_assignments.delete_all

        student.chapterable_assignments.create(
          account: student.account,
          chapterable: FactoryBot.create(:chapter),
          season: Season.current.year,
          primary: true
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

  describe "assigning a mentor to a chapter" do
    let(:mentor) { FactoryBot.create(:mentor) }
    let!(:chapter) { FactoryBot.create(:chapter) }

    before do
      sign_in(:admin)
    end

    context "when a mentor doesn't have a chapter assignment" do
      before do
        mentor.account.chapterable_assignments.delete_all
      end

      it "assigns the selected chapter to the mentor" do
        visit admin_participant_path(mentor.account)

        click_link "Assign to a chapter"

        select chapter.organization_name
        click_button "Save"

        expect(mentor.account.current_chapter).to eq(chapter)
      end
    end

    context "when a mentor is already assigned to a chapter" do
      before do
        mentor.account.chapterable_assignments.delete_all

        mentor.chapterable_assignments.create(
          account: mentor.account,
          chapterable: FactoryBot.create(:chapter),
          season: Season.current.year,
          primary: true
        )
      end

      it "reassigns the mentor to a newly selected chapter" do
        new_chapter = FactoryBot.create(:chapter, organization_name: "Kawaii chapter")

        visit admin_participant_path(mentor.account)

        click_link "Edit chapter"

        select new_chapter.organization_name
        click_button "Save"

        expect(mentor.account.current_chapter).to eq(new_chapter)
      end
    end
  end

  describe "assigning a chapter ambassador to a chapter" do
    let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }
    let!(:chapter) { FactoryBot.create(:chapter) }

    before do
      sign_in(:admin)
    end

    context "when a chapter ambassador doesn't have a chapter assignment" do
      before do
        chapter_ambassador.account.chapterable_assignments.delete_all
      end

      it "assigns the selected chapter to the chapter ambassador" do
        visit admin_participant_path(chapter_ambassador.account)

        click_link "Assign to a chapter"

        select chapter.organization_name
        click_button "Save"

        expect(chapter_ambassador.account.current_chapter).to eq(chapter)
      end
    end

    context "when a chapter ambassador is already assigned to a chapter" do
      before do
        chapter_ambassador.account.chapterable_assignments.delete_all

        chapter_ambassador.chapterable_assignments.create(
          account: chapter_ambassador.account,
          chapterable: FactoryBot.create(:chapter),
          season: Season.current.year,
          primary: true
        )
      end

      it "reassigns the chapter ambassador to a newly selected chapter" do
        new_chapter = FactoryBot.create(:chapter, organization_name: "Rippa chapter")

        visit admin_participant_path(chapter_ambassador.account)

        click_link "Edit chapter"

        select new_chapter.organization_name
        click_button "Save"

        expect(chapter_ambassador.account.current_chapter).to eq(new_chapter)
      end
    end
  end
end
