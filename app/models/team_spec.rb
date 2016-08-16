require "rails_helper"

RSpec.describe Team do
  it "assigns to the B division if all students are in Division B" do
    team = FactoryGirl.create(:team)
    younger_student = FactoryGirl.create(:student, date_of_birth: 13.years.ago)
    older_student = FactoryGirl.create(:student, date_of_birth: 14.years.ago)

    team.add_student(older_student)
    team.add_student(younger_student)

    expect(team.division).to eq(Division.a)
  end
end
