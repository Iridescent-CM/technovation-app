require "rails_helper"

RSpec.xdescribe "Uploading technical work to submissions", :js do
  %i[student mentor].each do |scope|
    before do
      SeasonToggles.team_submissions_editable!

      user = FactoryBot.create(scope, :onboarded, :on_team)
      user.teams.first.create_submission!({integrity_affirmed: true})

      visit "/logout"
      sign_in(user)

      if scope == :mentor
        click_link "Submit your Project"
      end

      if scope == :student
        click_link "Submit your project"
      end

      if scope == :mentor
        click_link "Edit submission"
      end
    end

    context "when development platform has been entered" do
      ["App Inventor", "Other"].each do |platform|
        context "and development platform (#{platform}) is not Thunkable" do
          before do
            if platform == "App Inventor"
              TeamSubmission.last.update!(development_platform: platform, app_inventor_app_name: "Test")
            else
              TeamSubmission.last.update!(development_platform: platform)
            end
          end

          context "and a valid file is uploaded" do
            it "allows the form to be submitted without issue" do
              click_link "Technical Additions"
              expect(page).to have_css("input[type=file]")

              ["aia", "zip"].each do |good_file|
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
              click_link "Technical Additions"
              expect(page).to have_css("input[type=file]")

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
      end

      context "and development platform is Thunkable" do
        let(:url) { "https://x.thunkable.com/projectPage/47d800b3aa47590210ad662249e63dd4" }

        before do
          TeamSubmission.last.update!({
            development_platform: "Thunkable",
            thunkable_project_url: url
          })
        end

        it "displays a text field with the URL filled in" do
          click_link "Technical Additions"
          expect(page).not_to have_css("input[type=file]")
          expect(page).to have_xpath("//input[@type='text' and @value='#{url}']")
        end
      end

      context "and development platform is Scratch" do
        context "and the scratch project url has been filled in" do
          let(:url) { "https://scratch.mit.edu/projects/694700505" }

          before do
            TeamSubmission.last.update!({
              development_platform: "Scratch",
              scratch_project_url: url
            })
          end

          it "displays a text field with the URL filled in" do
            click_link "Technical Additions"
            expect(page).not_to have_css("input[type=file]")
            expect(page).to have_xpath("//input[@type='text' and @value='#{url}']")
          end
        end

        context "and the scratch project url has not been filled in" do
          before do
            TeamSubmission.last.update!({
              development_platform: "Scratch",
              scratch_project_url: nil
            })
          end

          it "allows an sb3 file to be uploaded" do
            click_link "Technical Additions"
            expect(page).to have_css("input[type=file]")

            attach_file(
              "file",
              File.absolute_path("./spec/support/uploads/example.sb3"),
              class: "source-code-uploader__file"
            )

            expect(page).to have_selector(".source-code-uploader__error", visible: false)
            expect(page).to have_button("Upload", disabled: false)

          end
        end
      end
    end

    context "when development platform has not been entered" do
      it "displays the development platform selection" do
        click_link "Technical Additions"

        select "Thunkable", from: "Which coding language did your team use?"

        fill_in "What is the URL to your Thunkable project detail page?",
          with: "https://x.thunkable.com/projectPage/47d800b3aa47590210ad662249e63dd4"

        sleep 1

        click_button "Save"

        within(".development_platform.complete") do
          expect(page).to have_content "Thunkable"
          expect(page).to have_link "https://x.thunkable.com/projectPage/47d800b3aa47590210ad662249e63dd4"
        end

        click_link "Technical Elements"

        within(".source_code_url.complete") do
          expect(page).to have_link "https://x.thunkable.com/projectPage/47d800b3aa47590210ad662249e63dd4"
        end
      end
    end
  end
end
