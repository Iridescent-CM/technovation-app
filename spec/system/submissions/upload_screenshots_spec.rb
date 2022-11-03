require "rails_helper"

RSpec.xdescribe "Uploading images to submissions", :js do
  before { SeasonToggles.team_submissions_editable! }

  let(:student) { FactoryBot.create(:student, :onboarded, :on_team) }
  let(:submission) { FactoryBot.create(:submission, team: student.team) }

  before do
    sign_in(student)

    visit student_team_submission_path(submission, piece: :screenshots)
  end

  context "valid image file types" do
    it "allows gifs" do
      attach_file(
        "attach-screenshots",
        File.absolute_path("./spec/support/uploads/example.gif"),
        make_visible: true
      )

      expect(page).not_to have_css(".flash.flash--alert")
      expect(page).to have_css(".sortable-list__item")
    end

    it "allows pngs" do
      attach_file(
        "attach-screenshots",
        File.absolute_path("./spec/support/uploads/example.png"),
        make_visible: true
      )

      expect(page).not_to have_css(".flash.flash--alert")
      expect(page).to have_css(".sortable-list__item")
    end

    it "allows jpgs" do
      attach_file(
        "attach-screenshots",
        File.absolute_path("./spec/support/uploads/example.jpg"),
        make_visible: true
      )

      expect(page).not_to have_css(".flash.flash--alert")
      expect(page).to have_css(".sortable-list__item")
    end

    it "allows jpegs" do
      attach_file(
        "attach-screenshots",
        File.absolute_path("./spec/support/uploads/example.jpeg"),
        make_visible: true
      )

      expect(page).not_to have_css(".flash.flash--alert")
      expect(page).to have_css(".sortable-list__item")
    end
  end

  context "invalid image file types" do
    it "does not allow bmps" do
      attach_file(
        "attach-screenshots",
        File.absolute_path("./spec/support/uploads/example.bmp"),
        make_visible: true
      )

      expect(page).to have_css(".flash.flash--alert", text: "invalid file type")
      find(".flash .icon-close").click
    end

    it "does not allow pdfs" do
      attach_file(
        "attach-screenshots",
        File.absolute_path("./spec/support/uploads/example.pdf"),
        make_visible: true
      )

      expect(page).to have_css(".flash.flash--alert", text: "invalid file type")
      find(".flash .icon-close").click
    end

    it "does not allow docs" do
      attach_file(
        "attach-screenshots",
        File.absolute_path("./spec/support/uploads/example.docx"),
        make_visible: true
      )

      expect(page).to have_css(".flash.flash--alert", text: "invalid file type")
      find(".flash .icon-close").click
    end

    it "does not allow zipped files" do
      attach_file(
        "attach-screenshots",
        File.absolute_path("./spec/support/uploads/example.zip"),
        make_visible: true
      )

      expect(page).to have_css(".flash.flash--alert", text: "invalid file type")
      find(".flash .icon-close").click
    end
  end
end
