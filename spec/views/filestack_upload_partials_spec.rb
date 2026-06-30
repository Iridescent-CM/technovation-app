require "rails_helper"

# Upload partials must call enable_filestack! so the rebrand/submissions layouts
# load Filestack. When adding a new upload UI, add a context here — not a route list.
RSpec.describe "Filestack upload partials", type: :view do
  shared_examples "opts in to Filestack loading" do
    it "calls enable_filestack!" do
      expect(view).to receive(:enable_filestack!)

      render_partial
    end
  end

  describe "profiles/filestack_profile_image_upload" do
    def render_partial
      student = FactoryBot.create(:student, :geocoded)

      without_partial_double_verification do
        allow(view).to receive(:current_profile).and_return(student)
        allow(view).to receive(:current_scope).and_return("student")
        allow(view).to receive(:current_account).and_return(student.account)
      end

      render partial: "profiles/filestack_profile_image_upload"
    end

    include_examples "opts in to Filestack loading"
  end

  describe "filestack_uploads/team_photo_upload" do
    def render_partial
      team = FactoryBot.create(:team)
      assign(:team, team)

      without_partial_double_verification do
        allow(view).to receive(:current_team).and_return(team)
        allow(view).to receive(:current_scope).and_return("student")
      end

      render partial: "filestack_uploads/team_photo_upload"
    end

    include_examples "opts in to Filestack loading"
  end
end
