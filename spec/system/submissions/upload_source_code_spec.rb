require "rails_helper"

RSpec.describe "Uploading source code to submissions", :js do
  %i{student mentor}.each do |scope|
    before do
      SeasonToggles.team_submissions_editable!

      user = FactoryBot.create(scope, :onboarded, :on_team)
      user.teams.first.create_submission!({ integrity_affirmed: true })

      visit "/logout"
      sign_in(user)
      click_button "Submit your project"

      if scope == :mentor
        click_link "Edit this team's submission"
      end
    end

    context "when development platform has been entered" do
      context "and development platform is not Thunkable" do
        before do
          TeamSubmission.last.update!(development_platform: "Swift or XCode")
        end

        context "and a valid file is uploaded" do
          it "allows the form to be submitted without issue" do
            click_link "Upload your source code"
            expect(page).to have_css('input[type=file]')

            ['aia', 'apk', 'zip'].each do |good_file|
              attach_file(
                "file",
                File.absolute_path("./spec/support/uploads/example.#{good_file}"),
                class: "source-code-uploader__file"
              )

              expect(page).to have_selector(".source-code-uploader__error", visible: false)
              expect(page).to have_button("Upload", disabled: false)
            end
          end
        end

        context "and an invalid file is uploaded" do
          it "allows the form to be submitted without issue" do
            click_link "Upload your source code"
            expect(page).to have_css('input[type=file]')

            attach_file(
              "file",
              File.absolute_path("./spec/support/uploads/example.txt"),
              class: "source-code-uploader__file"
            )

            expect(page).to have_selector(".source-code-uploader__error", visible: true)
            expect(page).to have_button("Upload", disabled: true)
          end
        end
      end

      context "and development platform is Thunkable" do
        let(:url) { "https://x.thunkable.com/copy/47d800b3aa47590210ad662249e63dd4" }

        before do
          TeamSubmission.last.update!({
            development_platform: "Thunkable",
            thunkable_account_email: "our-team@thunkable.com",
            thunkable_project_url: url,
          })
        end

        it "displays a text field with the URL filled in" do
          click_link "Upload your source code"
          expect(page).not_to have_css('input[type=file]')
          expect(page).to have_xpath("//input[@type='text' and @value='#{url}']")
        end
      end
    end

    context "when development platform has not been entered" do
      it "displays the development platform selection" do
        click_link "Upload your source code"

        select "Thunkable", from: "Which development platform did your team use?"

        fill_in "What is the email address of your team's Thunkable account?",
          with: "our-team@thunkable.com"

        fill_in "What is the shareable URL of your Thunkable project?",
          with: "https://x.thunkable.com/copy/47d800b3aa47590210ad662249e63dd4"

        click_button "Save"

        within(".development_platform.complete") do
          expect(page).to have_content "Thunkable"
          expect(page).to have_link "https://x.thunkable.com/copy/47d800b3aa47590210ad662249e63dd4"
        end

        click_link "Code"

        within(".source_code_url.complete") do
          expect(page).to have_link "https://x.thunkable.com/copy/47d800b3aa47590210ad662249e63dd4"
        end
      end
    end
  end
end