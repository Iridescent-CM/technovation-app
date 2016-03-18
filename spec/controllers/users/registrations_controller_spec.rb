require 'rails_helper'

describe Users::RegistrationsController, type: :controller do
  describe "GET #new" do
    subject { get :new, role: user_role }
    let(:user_role) { 'student' }
    let(:is_opened) { true }

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]

      allow(Setting)
        .to receive(:registrationOpen?)
        .with(user_role)
        .and_return(is_opened)
    end

    it "returns http success" do
      is_expected.to have_http_status(:success)
    end

    it 'dont redirects to home' do
      is_expected.to_not redirect_to(:new_user_without_role)
    end

    context 'when the role registration is closed' do
      let(:is_opened) { false }

      it 'redirects to home' do
        is_expected.to redirect_to(:new_user_without_role)
      end
    end

    context 'when there is no role' do
      let(:user_role) { nil }
      
      it 'not checks if registration is open' do
        expect(Setting).to_not receive(:registrationOpen?)
        subject
      end

      it "returns http success" do
        is_expected.to have_http_status(:success)
      end

      it 'dont redirects to home' do
        is_expected.to_not redirect_to(:new_user_without_role)
      end

    end
  end
end
