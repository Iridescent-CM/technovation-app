require "rails_helper"

RSpec.describe StudentAccount do
  it "validates parent email against account email" do
    student = FactoryGirl.build(
      :student,
      email: "same+as@student.com",
      student_profile_attributes: FactoryGirl.attributes_for(
        :student_profile,
        parent_guardian_email: "same+as@student.com",
      ),
    )

    expect(student).not_to be_valid
    expect(student.errors["email"]).to eq([
      "cannot be the same as your parent/guardian's email"
    ])
  end
end
