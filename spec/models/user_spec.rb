require 'rails_helper'
require 'webmock'
include WebMock::API

describe User, type: :model do
  context '.save' do
    context 'when user is promoted to judging' do
      let(:user) do
        build(:user)
      end

      before do
        default_response = {
          status: 200,
          body: '{"results":[]}',
          headers: {}
        }

        User.skip_callback(
          :create,
          :add_to_campaign_list,
          :send_judge_signup_email,
          :send_mentor_signup_email,
          :email_parents_callback
        )
        stub_request(:any, /.*/).to_return(default_response)

        user.save(validate: false)

        allow(SignupMailer)
          .to receive(:judge_signup_email)
          .and_return double(deliver: nil)
      end

      it 'sends a signup_mail' do
        expect(SignupMailer).to receive(:judge_signup_email)

        User.first.update(judging: true)
      end

      context 'when already able to judge and the user data has updates' do
        let(:user) do
          build(:user, judging: true)
        end

        it 'do not send email' do
          expect(SignupMailer).to_not receive(:judge_signup_email)

          User.first.update(judging: true)
        end
      end
    end
  end
end
