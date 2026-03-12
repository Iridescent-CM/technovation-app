require "rails_helper"

RSpec.describe StudentProfile do
  describe ".onboarded" do
    it "lists only students with location, parental consent, and email confirmed" do
      expect {
        FactoryBot.create(:onboarding_student)
      }.not_to change {
        StudentProfile.onboarded.count
      }

      team = FactoryBot.build(:team, members_count: 0)
      team.save!

      past_team = FactoryBot.build(:team, members_count: 0)
      past_team.seasons = [Season.current.year - 1]
      past_team.save!

      expect {
        onboarded = FactoryBot.create(:onboarded_student)
        onboarded.account.update_column(
          :seasons,
          [Season.current.year - 1, Season.current.year]
        )
        TeamCreating.execute(past_team, onboarded, FakeController.new)
        TeamCreating.execute(team, onboarded, FakeController.new)
      }.to change {
        team.students.onboarded.count
      }.by(1)
    end
  end

  describe ".unmatched" do
    it "lists students without a team" do
      FactoryBot.create(:student, :on_team)
      unmatched_student = FactoryBot.create(:student)
      expect(StudentProfile.unmatched).to eq([unmatched_student])
    end

    it "only considers current students" do
      past = FactoryBot.create(:student)
      past.account.update(seasons: [Season.current.year - 1])

      current_unmatched_student = FactoryBot.create(:student)

      expect(StudentProfile.unmatched).to eq([current_unmatched_student])
    end

    it "only considers current memberships" do
      current_unmatched_student = nil

      Timecop.freeze(Date.new(Season.current.year - 1, 10, 2)) do
        current_unmatched_student = FactoryBot.create(:student)

        current_unmatched_student.teams.create!({
          division: Division.for(current_unmatched_student),
          name: "Last year",
          seasons: [Season.current.year - 1]
        })
      end

      RegisterToCurrentSeasonJob.perform_now(current_unmatched_student.account)

      expect(StudentProfile.unmatched).to eq([current_unmatched_student])
    end

    it "avoids duplicate students who had past memberships" do
      student = nil

      Timecop.freeze(Date.new(Season.current.year - 1, 10, 2)) do
        student = FactoryBot.create(:student)

        student.teams.create!({
          division: Division.for(student),
          name: "Last year",
          seasons: [Season.current.year - 1]
        })
      end

      Timecop.freeze(Date.new(Season.current.year - 2, 10, 2)) do
        RegisterToCurrentSeasonJob.perform_now(student.account)

        student.teams.create!({
          division: Division.for(student),
          name: "Two years ago",
          seasons: [Season.current.year - 2]
        })
      end

      RegisterToCurrentSeasonJob.perform_now(student.account)

      expect(StudentProfile.unmatched).to eq([student])
    end
  end

  describe ".in_region" do
    it "scopes to the given US ambassador's state" do
      FactoryBot.create(:student, :los_angeles)
      il_student = FactoryBot.create(:student, :chicago)
      il_ambassador = FactoryBot.create(:ambassador, :chicago)

      expect(
        StudentProfile.in_region(il_ambassador)
      ).to eq([il_student])
    end

    it "scopes to the given Int'l ambassador's country" do
      FactoryBot.create(:student)

      intl_student = FactoryBot.create(:student, :brazil)
      intl_ambassador = FactoryBot.create(:ambassador, :brazil)

      expect(
        StudentProfile.in_region(intl_ambassador)
      ).to eq([intl_student])
    end

    it "works with secondary region searches" do
      br = FactoryBot.create(:student, :brazil)
      dhurma = FactoryBot.create(:student, :dhurma)
      najran = FactoryBot.create(:student, :najran)

      FactoryBot.create(:student, :los_angeles)

      chapter_ambassador = FactoryBot.create(:ambassador, :brazil,
        secondary_regions: ["Najran Province, SA"])

      expect(StudentProfile.in_region(chapter_ambassador)).to contain_exactly(
        br, dhurma, najran
      )
    end
  end

  describe "in_parental_consent_text_message_country?" do
    it "returns true when student country is in list of sms enabled countries" do
      student = FactoryBot.create(:student, :chicago)

      expect(student.in_parental_consent_text_message_country?).to eq(true)
    end

    it "returns false when student country is not in list of sms enabled countries" do
      student = FactoryBot.create(:student, :najran)

      expect(student.in_parental_consent_text_message_country?).to eq(false)
    end
  end

  describe "parent/guardian email validations" do
    it "requires a valid parent/guardian email address" do
      student_profile = FactoryBot.build(
        :student_profile,
        parent_guardian_email: "someinvalidemailaddress"
      )

      expect(student_profile).to be_invalid
      expect(student_profile.errors[:parent_guardian_email]).to include(
        "does not appear to be an email address"
      )
    end
  end

  describe "parent/guardian first and last name" do
    let(:student_profile) do
      FactoryBot.build(:student_profile,
        parent_guardian_name: parent_guardian_name)
    end

    context "when the parent/guardian name has more than two parts" do
      let(:parent_guardian_name) { "Pandy Paws the Cat" }

      it "returns the first part (separated by whitespace) as the first name" do
        expect(student_profile.parent_guardian_first_name).to eq("Pandy")
      end

      it "returns the remaining parts (separated by whitespace) as the last name" do
        expect(student_profile.parent_guardian_last_name).to eq("Paws the Cat")
      end
    end

    context "when the parent/guardian name has exactly two parts" do
      let(:parent_guardian_name) { "Mama Box" }

      it "returns the first part as the first name" do
        expect(student_profile.parent_guardian_first_name).to eq("Mama")
      end
      it "returns the second part as the last name" do
        expect(student_profile.parent_guardian_last_name).to eq("Box")
      end
    end

    context "when the parent/guardian name only has one name" do
      let(:parent_guardian_name) { "Carlita" }

      it "returns the only name as the first name" do
        expect(student_profile.parent_guardian_first_name).to eq("Carlita")
      end

      it "doesn't return anything for the last name (since there is only one name)" do
        expect(student_profile.parent_guardian_last_name).to eq(nil)
      end
    end

    context "when the parent/guardian name is blank" do
      let(:parent_guardian_name) { nil }

      it "doesn't return anything for the first name" do
        expect(student_profile.parent_guardian_first_name).to eq(nil)
      end

      it "doesn't return anything for the last name" do
        expect(student_profile.parent_guardian_last_name).to eq(nil)
      end
    end
  end

  it "allows ON FILE as the email ONLY by admin action" do
    profile = FactoryBot.build(:student_profile, parent_guardian_email: "ON FILE")
    expect(profile).not_to be_valid

    profile.parent_guardian_email = nil
    profile.save!
    profile.update_column(:parent_guardian_email, "ON FILE")

    expect(profile.reload).to be_valid
    expect(profile.parent_guardian_email).to eq("ON FILE")

    expect(
      profile.update(school_name: "some other change works")
    ).to be true
  end

  it "re-sends the parental consent on update of parent email" do
    student = FactoryBot.create(:student)

    ActionMailer::Base.deliveries.clear

    expect {
      student.update(parent_guardian_email: "something@else.com")
    }.to change {
      ActionMailer::Base.deliveries.count
    }.from(0).to(1)

    mail = ActionMailer::Base.deliveries.last

    expect(mail.to).to eq(["something@else.com"])
    expect(mail.subject).to include("Your daughter")
  end

  it "destroys the original parental consent on update of parent email" do
    profile = FactoryBot.create(:student_profile)
    consent = profile.reload.create_parental_consent(
      FactoryBot.attributes_for(:parental_consent)
    )

    profile.update(parent_guardian_email: "something@else.com")

    expect(profile.reload.parental_consent).to be_pending
  end

  context "when the parent/guardian email address has been updated" do
    let(:new_parent_guardian_email_address) { "acoolparent@example.com" }

    it "updates the parent/guardian in the CRM" do
      student_profile = FactoryBot.create(
        :student_profile,
        parent_guardian_email: "parenttrap@example.com"
      )

      expect(CRM::UpsertContactInfoJob).to receive(:perform_later)
        .with(
          account_id: student_profile.account.id,
          profile_type: "student"
        )

      student_profile.update(parent_guardian_email: new_parent_guardian_email_address)
    end
  end

  context "when the parent/guardian email address has been updated because of a paper parental consent" do
    let(:new_parent_guardian_email_address) do
      ConsentForms::PARENT_GUARDIAN_EMAIL_ADDRESS_FOR_A_PAPER_CONSENT
    end

    it "does not update the parent/guardian in the CRM" do
      student_profile = FactoryBot.create(
        :student_profile,
        parent_guardian_email: "oldparentemail@example.com"
      )

      expect(CRM::UpsertContactInfoJob).not_to receive(:perform_later)
        .with(
          account_id: student_profile.account.id,
          profile_type: "student"
        )

      student_profile.update(parent_guardian_email: new_parent_guardian_email_address)
    end
  end

  describe "#parental_consent_text_messages_remaining" do
    let(:student) { FactoryBot.create(:student_profile) }

    it "returns 5 when no messages are sent" do
      expect(student.parental_consent_text_messages_remaining).to eq(5)
    end

    it "returns 1 when 4 text messages are sent" do
      FactoryBot.create_list(:text_message, 4, :whatsapp, account: student.account)
      expect(student.parental_consent_text_messages_remaining).to eq(1)
    end
  end

  describe "#parental_consent_text_message_limit_reached?" do
    let(:student) { FactoryBot.build(:student_profile, :with_parent_guardian_phone_number) }

    it "returns false when 3 text messages are sent" do
      FactoryBot.create_list(:text_message, 3, :whatsapp, account: student.account)
      expect(student.parental_consent_text_message_limit_reached?).to be false
    end

    it "returns true when 5 text messages are sent" do
      FactoryBot.create_list(:text_message, 5, :whatsapp, account: student.account)
      expect(student.parental_consent_text_message_limit_reached?).to be true
    end
  end

  describe "#can_send_parental_consent_text_message?" do
    let(:student) { FactoryBot.build(:student_profile, :with_parent_guardian_phone_number) }
    it "returns true when phone number is entered and text message limit is not reached" do
      expect(student.can_send_parental_consent_text_message?).to be true
    end

    it "returns false when phone number is missing" do
      student.update(parent_guardian_phone_number: nil)
      expect(student.can_send_parental_consent_text_message?).to be false
    end

    it "returns false when 5 text messages are sent" do
      FactoryBot.create_list(:text_message, 5, :whatsapp, account: student.account)
      expect(student.can_send_parental_consent_text_message?).to be false
    end
  end

  describe "parent guardian phone number" do
    let(:student) { FactoryBot.build(:student_profile) }

    context "when phone number includes parenthesis and dash characters" do
      before do
        student.parent_guardian_phone_country_code = "+1"
        student.parent_guardian_phone_number = "(415) 236-2665"
        student.parent_guardian_text_message_opt_in = "1"
      end

      it "formats the number to E.164 standard" do
        expect(student).to be_valid
        expect(student.parent_guardian_phone_number).to eq("+14152362665")
      end
    end

    context "when phone number has no additional formatting or characters" do
      before do
        student.parent_guardian_phone_country_code = "+1"
        student.parent_guardian_phone_number = "4152362665"
        student.parent_guardian_text_message_opt_in = "1"
      end

      it "formats the number to E.164 standard" do
        expect(student).to be_valid
        expect(student.parent_guardian_phone_number).to eq("+14152362665")
      end
    end

    context "when a user does not select a country code" do
      before do
        student.parent_guardian_phone_country_code = nil
        student.parent_guardian_phone_number = "4152362665"
        student.parent_guardian_text_message_opt_in = "1"
      end

      it "is invalid" do
        expect(student).not_to be_valid
        expect(student.errors[:parent_guardian_phone_country_code]).to include("must be selected")
      end
    end

    context "when phone number includes alphanumeric characters" do
      before do
        student.parent_guardian_phone_country_code = "+1"
        student.parent_guardian_phone_number = "415236abc"
        student.parent_guardian_text_message_opt_in = "1"
      end

      it "is invalid" do
        expect(student).not_to be_valid
        expect(student.errors[:parent_guardian_phone_number]).to include("is not a valid phone number")
      end
    end

    context "when phone number includes country code" do
      before do
        student.parent_guardian_phone_country_code = "+1"
        student.parent_guardian_phone_number = "+14152362665"
        student.parent_guardian_text_message_opt_in = "1"
      end

      it "does not double the country code" do
        expect(student).to be_valid
        expect(student.parent_guardian_phone_number).to eq("+14152362665")
      end
    end
  end
end
