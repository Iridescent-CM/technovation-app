require "rails_helper"

RSpec.describe "Mentor Profile Requests", type: :request do
  describe "GET #edit" do
    context "for a mentor with a grandfathered under-18 stored birthdate" do
      let(:mentor) { FactoryBot.create(:mentor, meets_minimum_age_requirement: true) }
      let(:under_18_birth_year) { 15.years.ago.to_date.year }

      before do
        mentor.account.update_column(:date_of_birth, 15.years.ago.to_date)
        mentor.account.reload

        sign_in(mentor)
        get edit_mentor_profile_path
      end

      it "renders successfully" do
        expect(response).to have_http_status(:ok)
      end

      it "includes the stored birth year as a selectable, selected option, so an unrelated edit does not force the year to change" do
        expect(response.body).to include(
          %(<option value="#{under_18_birth_year}" selected="selected">#{under_18_birth_year}</option>)
        )
      end
    end
  end
end
