require "rails_helper"

describe StudentToMentorConverter do
  let(:student_to_mentor_converter) {
    StudentToMentorConverter.new(account: account)
  }
  let(:account) { double(Account, name: "Fizzy Izzy") }
  let(:student_profile) { instance_double(StudentProfile, school_name: "Slytherin") }

  before do
    allow(account).to receive(:create_mentor_profile!)
    allow(account).to receive(:student_profile).and_return(student_profile)
    allow(account).to receive(:update_columns)
    allow(student_profile).to receive(:delete)
    allow(student_profile).to receive_message_chain(:join_requests, :pending, :delete_all)
  end

  it "creates a mentor profile (that's marked as being a former student)" do
    expect(account).to receive(:create_mentor_profile!)
      .with({
        former_student: true,
        mentor_type_ids: [MentorType.find_by(name: "Technovation alumna").id],
        job_title: "Technovation Alumnus",
        school_company_name: student_profile.school_name
      })

    student_to_mentor_converter.call
  end

  it "sets the gender on the account to 'Prefer not to say'" do
    expect(account).to receive(:update_columns)
      .with({
        gender: "Prefer not to say"
      })

    student_to_mentor_converter.call
  end

  it "deletes any pending join requests" do
    expect(student_profile).to receive_message_chain(:join_requests, :pending, :delete_all)

    student_to_mentor_converter.call
  end

  it "deletes the student profile on the account" do
    expect(account).to receive_message_chain(:student_profile, :delete)

    student_to_mentor_converter.call
  end

  it "returns a success result" do
    expect(student_to_mentor_converter.call.success?).to eq(true)
  end

  it "returns a success message" do
    expect(student_to_mentor_converter.call.message).to eq({
      success: "Fizzy Izzy has been successfully converted to a mentor"
    })
  end

  context "when the account doesn't have a student profile" do
    before do
      allow(account).to receive(:student_profile).and_return(nil)
    end

    it "does not return a success result" do
      expect(student_to_mentor_converter.call.success?).to eq(false)
    end

    it "returns an error message" do
      expect(student_to_mentor_converter.call.message).to eq({
        error: "This account does not have a student profile"
      })
    end
  end

  context "when a mentor profile already exists for the account" do
    before do
      allow(account).to receive(:create_mentor_profile!).and_raise(
        ActiveRecord::RecordNotUnique
      )
    end

    it "does not return a success result" do
      expect(student_to_mentor_converter.call.success?).to eq(false)
    end

    it "returns an error message" do
      expect(student_to_mentor_converter.call.message).to eq({
        error: "A mentor profile already exists for this account"
      })
    end
  end
end
