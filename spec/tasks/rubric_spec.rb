require 'rails_helper'

describe "rubric:create_for_brazil", type: :rake do
  after do
    subject.execute
  end
  
  it { is_expected.to depend_on(:environment) }
  
  it 'calls create to brazil' do
    expect(Rubric::CreateToBrazil).to receive(:run!)
  end
end
