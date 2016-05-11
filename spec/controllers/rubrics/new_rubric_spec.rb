require "rails_helper"

RSpec.describe RubricsController do
  describe "GET #new" do
    let(:region) { FactoryGirl.create(:region) }
    let(:event) { FactoryGirl.create(:event, region: region) }
    let(:team) { FactoryGirl.create(:team, event: event, region: region) }

    before do
      Judging.open!(:quarterfinal, Date.today - 1)
      Judging.close!(:quarterfinal, Date.today + 1)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @request.env['HTTP_REFERER'] = rubrics_url
    end

    context "judge role rubric policy" do
      let(:judge) { FactoryGirl.create(:user, role: :judge,
                                              judging_region_id: region.id,
                                              event_id: event,
                                              conflict_region_id: 2) }

      it "allows the valid judge" do
        sign_in(judge)
        get :new, team: team.id
        expect(response.status).to eq(200)
      end

      it "doesn't allow access from an empty HTTP_REFERER" do
        sign_in(judge)

        [nil, "", " ", root_url, events_url].each do |bad_referer|
          @request.env['HTTP_REFERER'] = bad_referer
          get :new, team: team.id
          expect(response.status).to eq(302)
        end

        @request.env['HTTP_REFERER'] = rubrics_url
        get :new, team: team.id
        expect(response.status).to eq(200)
      end

      it "restricts judges in the conflict region" do
        skip
        judge.update_attributes(conflict_region_id: region.id)
        sign_in(judge)

        get :new, team: team.id
        expect(response.status).to eq(302)
      end

      it "restricts judges not in the same event" do
        skip
        other_event = FactoryGirl.create(:event)
        judge.update_attributes(conflict_region_id: 2, event: other_event)
        sign_in(judge)

        get :new, team: team.id
        expect(response.status).to eq(302)
      end

      it "restricts judges not assigned the same judging region" do
        skip
        judge.update_attributes(conflict_region_id: 2,
                                judging_region_id: region.id + 1)
        sign_in(judge)

        get :new, team: team.id
        expect(response.status).to eq(302)
      end
    end

    context "judging enabled rubric policy" do
      let(:judge) { FactoryGirl.create(:user, role: %i{coach mentor}.sample,
                                              judging: true,
                                              judging_region_id: region.id,
                                              event_id: event,
                                              conflict_region_id: 2) }


      it "restricts against judges assigned through team requests" do
        skip
        judge.team_requests.create!(team: team)
        sign_in(judge)

        get :new, team: team.id
        expect(response.status).to eq(302)
      end

      it "allows a coach/mentor outside of a team request" do
        judge.team_requests.destroy
        sign_in(judge)

        get :new, team: team.id
        expect(response.status).to eq(200)
      end
    end
  end
end
