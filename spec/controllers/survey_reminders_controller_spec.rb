require "rails_helper"

%i[mentor student].each do |scope|
  RSpec.describe "#{scope.to_s.capitalize}::SurveyRemindersController".constantize do
    describe "POST #create" do
      it "requires authentication" do
        post :create
        expect(response).to redirect_to(signin_path)
      end

      it "sets the #{scope} as being reminded about the survey" do
        user = FactoryBot.create(scope)
        time = Time.current

        sign_in(user)

        Timecop.freeze(time) do
          expect {
            post :create
          }.to change {
            user.reload.account.reminded_about_survey_count
          }.from(0).to(1)
        end

        expect(user.account.reminded_about_survey_at.to_i).to eq(time.to_i)
      end
    end
  end
end
