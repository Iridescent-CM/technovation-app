require 'rails_helper'

describe 'Mentors', type: :request do
  describe 'GET /mentors' do
    subject { response }
    let(:mentor_amount) { 5 }
    let!(:mentors) { create_list(:user, 5, :mentor) }

    before do
      allow(Setting).to receive(:year).and_return(2016)
      get mentors_path
    end

    it { is_expected.to have_http_status(200) }
    it { is_expected.to render_template(:index) }

    context 'when there is not mentor' do
      let(:mentors) { nil }
      it { is_expected.to have_http_status(200) }
      it { is_expected.to render_template(:index) }
    end
  end
end
