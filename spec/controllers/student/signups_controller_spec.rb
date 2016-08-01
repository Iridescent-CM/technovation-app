require "rails_helper"

RSpec.describe Student::SignupsController do
  describe "POST #create" do
    it "calls RegisterStudent" do
      expect(RegisterStudent).to receive(:call).with(instance_of(StudentAccount),
                                                     instance_of(Student::SignupsController))
      post :create, student_account: FactoryGirl.attributes_for(:student)
    end
  end
end
