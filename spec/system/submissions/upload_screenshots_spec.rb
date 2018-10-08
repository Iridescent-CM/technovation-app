require "rails_helper"

RSpec.describe "Uploading screenshots to submissions", :js do
  it "does not allow invalid file types" do
    SeasonToggles.team_submissions_editable!

    student = FactoryBot.create(:student, :onboarded, :on_team)
    submission = student.team.create_submission!(integrity_affirmed: true)
    sign_in(student)

    ['bmp', 'docx', 'pdf', 'zip'].each do |bad_file|
      visit student_team_submission_path(submission, piece: :screenshots)
      attach_file(
        "attach-screenshots",
        File.open("./spec/support/uploads/example.#{bad_file}"),
        make_visible: true
      )
      expect(page).to have_css(".flash.flash--alert", text: "invalid file type")
    end

    ['jpg', 'jpeg', 'gif', 'png'].each do |good_file|
      visit student_team_submission_path(submission, piece: :screenshots)
      attach_file(
        "attach-screenshots",
        File.open("./spec/support/uploads/example.#{good_file}"),
        make_visible: true
      )
      expect(page).not_to have_css(".flash.flash--alert")
    end
  end
end