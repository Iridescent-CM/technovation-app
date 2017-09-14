require "rails_helper"

RSpec.describe StudentProfile do
  describe ".unmatched" do
    it "lists students without a team" do
      FactoryGirl.create(:student, :on_team)
      unmatched_student = FactoryGirl.create(:student)
      expect(StudentProfile.unmatched).to eq([unmatched_student])
    end

    it "only considers current students" do
      past = FactoryGirl.create(:student)
      past.account.update(seasons: [Season.current.year - 1])

      current_unmatched_student = FactoryGirl.create(:student)

      expect(StudentProfile.unmatched).to eq([current_unmatched_student])
    end

    it "only considers current memberships" do
      current_unmatched_student = nil

      Timecop.freeze(Date.new(Season.current.year - 1, 10, 2)) do
        current_unmatched_student = FactoryGirl.create(:student)

        current_unmatched_student.teams.create!({
          division: Division.for(current_unmatched_student),
          name: "Last year",
          seasons: [Season.current.year - 1],
        })
      end

      RegisterToCurrentSeasonJob.perform_now(current_unmatched_student.account)

      expect(StudentProfile.unmatched).to eq([current_unmatched_student])
    end

    it "avoids duplicate students who had past memberships" do
      student = nil

      Timecop.freeze(Date.new(Season.current.year - 1, 10, 2)) do
        student = FactoryGirl.create(:student)

        student.teams.create!({
          division: Division.for(student),
          name: "Last year",
          seasons: [Season.current.year - 1],
        })
      end

      Timecop.freeze(Date.new(Season.current.year - 2, 10, 2)) do
        RegisterToCurrentSeasonJob.perform_now(student.account)

        student.teams.create!({
          division: Division.for(student),
          name: "Two years ago",
          seasons: [Season.current.year - 2],
        })
      end

      RegisterToCurrentSeasonJob.perform_now(student.account)

      expect(StudentProfile.unmatched).to eq([student])
    end
  end

  describe ".in_region" do
    it "scopes to the given US ambassador's state" do
      FactoryGirl.create(
        :student,
        city: "Los Angeles",
        state_province: "CA",
        country: "US"
      )

      il_student = FactoryGirl.create(:student)
      il_ambassador = FactoryGirl.create(:ambassador)

      expect(
        StudentProfile.in_region(il_ambassador)
      ).to eq([il_student])
    end

    it "scopes to the given Int'l ambassador's country" do
      FactoryGirl.create(:student)

      intl_student = FactoryGirl.create(
        :student,
        city: "Salvador",
        state_province: "Bahia",
        country: "Brazil"
      )

      intl_ambassador = FactoryGirl.create(
        :ambassador,
        city: "Salvador",
        state_province: "Bahia",
        country: "Brazil"
      )

      expect(
        StudentProfile.in_region(intl_ambassador)
      ).to eq([intl_student])
    end
  end

  it "at least wants parent/guardian email to look like an email" do
    FactoryGirl.create(:student, email: "noway@jose.com")
    profile = FactoryGirl.build(
      :student_profile,
      parent_guardian_email: "nowayjose.com"
    )

    expect(profile).not_to be_valid
    expect(profile.errors[:parent_guardian_email]).to include(
      "does not appear to be an email address"
    )

    profile.parent_guardian_email = "okeay@jose.com"
    expect(profile).to be_valid
  end

  it "allows ON FILE as the email ONLY by admin action" do
    profile = FactoryGirl.build(:student_profile, parent_guardian_email: "ON FILE")
    expect(profile).not_to be_valid

    profile.parent_guardian_email = nil
    profile.save!
    profile.update_column(:parent_guardian_email, "ON FILE")

    expect(profile.reload).to be_valid
    expect(profile.parent_guardian_email).to eq("ON FILE")

    expect(
      profile.update_attributes(school_name: "some other change works")
    ).to be true
  end

  it "doesn't allow a student email to be used as parent email" do
    FactoryGirl.create(:student, email: "noway@jose.com")
    profile = FactoryGirl.build(
      :student_profile,
      parent_guardian_email: "noway@jose.com"
    )

    expect(profile).not_to be_valid
    expect(profile.errors[:parent_guardian_email]).to include(
      "cannot match another student's email"
    )
  end

  it "re-sends the parental consent on update of parent email" do
    FactoryGirl.create(:student_profile)
               .update_attributes(parent_guardian_email: "something@else.com")

    mail = ActionMailer::Base.deliveries.last
    expect(mail).to be_present, "no email sent"
    expect(mail.to).to eq(["something@else.com"])
    expect(mail.subject).to include("Your daughter")
  end

  it "voids the original parental consent on update of parent email" do
    profile = FactoryGirl.create(:student_profile)
    consent = profile.reload.create_parental_consent(
      FactoryGirl.attributes_for(:parental_consent)
    )

    profile.update_attributes(parent_guardian_email: "something@else.com")

    expect(consent).to be_voided
  end

  it "re-subscribes new email addresses" do
    profile = FactoryGirl.create(:student_profile)

    expect(UpdateEmailListJob).to receive(:perform_later)
      .with(profile.parent_guardian_email, "new@parent-email.com",
            profile.parent_guardian_name, "PARENT_LIST_ID")

    profile.update_attributes(parent_guardian_email: "new@parent-email.com")
  end
end
