require 'rails_helper'

describe MentorsController, type: :controller do
  describe 'index' do
    subject { get :index }
    let(:season_year) { 2016 }
    let(:mentors) { build_list(:user, 10, :mentor) }
    let(:relation) { double(ActiveRecord::Relation) }
    before do
      allow(Setting).to receive(:year).and_return(season_year)
      allow(User).to receive(:can_mentor).and_return relation
      allow(relation)
        .to receive_message_chain(:joins, :where)
        .and_return(mentors)
    end

    describe '#pagination' do
      it 'calls page method' do
        expect(relation).to receive(:page)
        subject
      end

      context 'whe we pass a page params' do
        subject { get :index, params }
        let(:params) { { page: page } }
        let(:page) { Faker::Number.number(1) }

        it 'calls page method with page params' do
          expect(relation).to receive(:page).with(page)
          subject
        end
      end
    end
  end
end
