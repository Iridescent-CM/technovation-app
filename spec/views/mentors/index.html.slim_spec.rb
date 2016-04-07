require 'rails_helper'

describe 'mentors/index.html.slim', type: :view do
  subject { render }
  let(:mentors) { create_list(:user, amount_mentor, :mentor) }
  let(:amount_mentor) { 20 }
  let(:taken) { double }
  let(:page) { 1 }
  let(:per_page) { 10 }
  let(:paginable_mentors) do
    Kaminari.paginate_array(mentors).page(page).per(per_page)
  end

  before do
    assign(:mentors, paginable_mentors)
    assign(:taken, taken)

    allow(taken).to receive(:exclude?).and_return(true)
  end

  it { is_expected.to have_selector('.mentor-item', count: 10) }

  context 'where there is not teams' do
    let(:mentors) { [] }
    it { is_expected.to have_selector('.mentor-item', count: 0) }
  end

  describe 'pagination' do
    it { is_expected.to have_selector('.pagination') }
  end
end
