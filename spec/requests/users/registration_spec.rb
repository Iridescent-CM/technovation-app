require 'rails_helper'

describe 'Users::Registrations', type: :request do
  describe 'GET users/sign_up' do
    it 'shows all buttons' do
      get 'users/sign_up'
      expect(response).to have_http_status(200)
      expect(response).to render_template(:choose)
    end
  end

  describe 'GET users/sign_up/:role' do
    shared_examples 'shows the registration form for' do |role|
      before do
        create(:setting, "#{role}_registration_open".to_sym)
      end

      it 'shows all buttons' do
        get 'users/sign_up/', role: role
        expect(response).to have_http_status(200)
        expect(response).to render_template('devise/registrations/new')
      end
    end

    it_behaves_like 'shows the registration form for', 'student'
    it_behaves_like 'shows the registration form for', 'mentor'
    it_behaves_like 'shows the registration form for', 'coach'
    it_behaves_like 'shows the registration form for', 'judge'
  end
end
