require "rails_helper"

RSpec.describe SurveyCompletionsController do
  describe "GET #show" do
    it "requires a login" do
      get :show
      expect(response).to redirect_to(signin_path)
    end

    %i[student mentor].each do |scope|
      it "tracks the #{scope} as having taken the survey" do
        user = FactoryBot.create(scope)
        sign_in(user)

        time = Time.current

        Timecop.freeze(time) do
          get :show
        end

        expect(user.reload.account).to be_took_program_survey
        expect(user.account.pre_survey_completed_at.to_i).to eq(time.to_i)
      end

      it "redirects to their dashboard" do
        user = FactoryBot.create(scope)
        sign_in(user)

        get :show

        expect(response).to redirect_to(send("#{scope}_dashboard_path"))
      end
    end
  end
end
