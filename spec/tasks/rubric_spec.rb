require 'rails_helper'

describe "rubric:create_for_brazil", type: :rake do
  let(:year) { 2016 }
  
  before do
    allow(Setting).to receive(:year).and_return(year)
  end

  after do
    subject.execute
  end

  it { is_expected.to depend_on(:environment) }

  it 'get users from BR' do
    expect(User).to receive(:judges_from).with('BR')
  end

  it 'gets latin america regions' do
    expect(Region).to receive(:where).with(id: [1,5])
  end

  it 'gets current year' do
    expect(Setting).to receive(:year)
  end

end
