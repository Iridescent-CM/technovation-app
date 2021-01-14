require "rails_helper"

RSpec.describe "Uploading images to submissions", :js do
  before { SeasonToggles.team_submissions_editable! }

  it "does not allow invalid file types" do
    student = FactoryBot.create(:student, :onboarded, :on_team)
    submission = student.team.create_submission!(integrity_affirmed: true)
    sign_in(student)

    visit student_team_submission_path(submission, piece: :screenshots)

    ['jpg', 'jpeg', 'gif', 'png'].each do |good_file|
      attach_file(
        "attach-screenshots",
        File.absolute_path("./spec/support/uploads/example.#{good_file}"),
        make_visible: true
      )
      expect(page).not_to have_css(".flash.flash--alert")
      expect(page).to have_css(".sortable-list__item")
    end

    ['bmp', 'docx', 'pdf', 'zip'].each do |bad_file|
      attach_file(
        "attach-screenshots",
        File.absolute_path("./spec/support/uploads/example.#{bad_file}"),
        make_visible: true
      )
      expect(page).to have_css(".flash.flash--alert", text: "invalid file type")
      find(".flash .icon-close").click
    end
  end

  it "does not allow invalid file types for mentors" do
    mentor = FactoryBot.create(:mentor, :onboarded, :on_team)
    submission = mentor.teams.last.create_submission!(integrity_affirmed: true)
    sign_in(mentor)

    visit mentor_team_submission_path(submission, piece: :screenshots)

    ['jpg', 'jpeg', 'gif', 'png'].each do |good_file|
      attach_file(
        "attach-screenshots",
        File.absolute_path("./spec/support/uploads/example.#{good_file}"),
        make_visible: true
      )
      expect(page).not_to have_css(".flash.flash--alert")
      expect(page).to have_css(".sortable-list__item")
    end

    ['bmp', 'docx', 'pdf', 'zip'].each do |bad_file|
      attach_file(
        "attach-screenshots",
        File.absolute_path("./spec/support/uploads/example.#{bad_file}"),
        make_visible: true
      )
      expect(page).to have_css(".flash.flash--alert", text: "invalid file type")
      find(".flash .icon-close").click
    end
  end
end
