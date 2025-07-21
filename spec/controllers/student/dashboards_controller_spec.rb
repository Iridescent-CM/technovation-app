require "rails_helper"

RSpec.describe Student::DashboardsController do
  describe "GET #show" do
    context "when visitors have lat, lng stored in the DB" do
      it "adds the visitor's lat, lng" do
        student = FactoryBot.create(:student, :onboarded)
        sign_in(student)
        cookie =

          expect {
            get :show
          }.to change {
            cookie = controller.get_cookie(CookieNames::IP_GEOLOCATION)
            cookie && cookie["ip_address"]
          }.to(
            request.remote_ip
          ).and change {
            cookie = controller.get_cookie(CookieNames::IP_GEOLOCATION)
            cookie && cookie["coordinates"]
          }.to(
            [student.latitude, student.longitude]
          )
      end
    end

    it "does not load events when RPE selection is off" do
      student = FactoryBot.create(:student, :submitted, :junior)
      event = FactoryBot.create(:event, :junior)

      sign_in(student)

      SeasonToggles.select_regional_pitch_event_on!
      get :show
      expect(assigns[:regional_events]).to eq([event])

      SeasonToggles.select_regional_pitch_event_off!
      get :show
      expect(assigns[:regional_events]).to be_empty
    end

    it "does not generate certificates when certificates are off" do
      student = FactoryBot.create(:student, :quarterfinalist)

      sign_in(student)

      SeasonToggles.display_scores_off!

      expect {
        get :show
      }.not_to change {
        student.certificates.count
      }
    end
  end

  describe "POST #unset_force_chapterable_selection" do
    let(:student_profile) { FactoryBot.create(:student) }

    before do
      student_profile.account.update(force_chapterable_selection: true)

      sign_in(student_profile)
    end

    it "unsets the `force_chapterable_selection` flag" do
      post :unset_force_chapterable_selection

      expect(student_profile.account.reload.force_chapterable_selection).to eq(false)
    end
  end
end
