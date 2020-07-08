require "rails_helper"
require "./lib/fill_pdfs"

RSpec.describe Account do
  let(:season_with_templates) { Season.new(2020) }
  before {
    allow(Season).to receive(:current).and_return(season_with_templates)
  }

  context "validations" do
    describe "student email address validations" do
      let!(:student_account) { FactoryBot.build_stubbed(:account, email: student_email_address) }
      let!(:student_profile) { FactoryBot.build_stubbed(:student_profile,
        account: student_account,
        parent_guardian_email: parent_guardian_email_address
      ) }

      context "when the student's email address matches the parent/guardian's email address" do
        let(:student_email_address) { "rose@example.com" }
        let(:parent_guardian_email_address) { "rose@example.com" }

        it "is not valid and adds an error to the email attribute" do
          expect(student_account).not_to be_valid
          expect(student_account.errors[:email]).to include "cannot be the same as parent/guardian email address"
        end
      end

      context "when the student's email address is different than the parent/guardian's email address" do
        let(:student_email_address) { "crocus@example.com" }
        let(:parent_guardian_email_address) { "iris@example.com" }

        it "is valid and does not add an error to the email attribute" do
          expect(student_account).to be_valid
          expect(student_account.errors[:email]).to be_blank
        end
      end
    end
  end

  it "formats the country as a short code before validating" do
    account = Account.new(country: "United States")
    account.valid?
    expect(account[:country]).to eq("US")
  end

  it "formats states as short codes before validating" do
    account = Account.new(city: "Salvador", state_province: "Bahia", country: "Brazil")
    account.valid?
    expect(account[:country]).to eq("BR")
    expect(account[:state_province]).to eq("BA")
  end

  it "stores the short codes in the database" do
    student = FactoryBot.create(
      :student,
      city: "Chicago",
      state_province: "Illinois",
      country: "United States"
    )

    expect(student.reload.account[:country]).to eq("US")
    expect(student.account[:state_province]).to eq("IL")

    student = FactoryBot.create(
      :student,
      city: "Nablus",
      state_province: nil,
      country: "Palestine, State of"
    )

    expect(student.reload.account[:country]).to eq("PS")
  end

  it "removes current certificates if the name is changed" do
    account = FactoryBot.create(:judge, :certified_certificate).account

    FillPdfs.(account)

    expect {
      account.update(first_name: "Change")
    }.to change {
      account.reload.current_certified_judge_certificates.count
    }.from(1).to(0)

    FillPdfs.(account)

    expect {
      account.update(last_name: "Change!!!")
    }.to change {
      account.reload.current_certified_judge_certificates.count
    }.from(1).to(0)
  end

  it "validates email uniqueness with dots" do
    FactoryBot.create(:account, email: "remove.dots@gmail.com")
    account = FactoryBot.build(:account, email: "removedots@gmail.com")

    expect(account).not_to be_valid
    expect(account.errors[:email]).to include("has already been taken")

    account.email = "something@else.com"
    expect(account).to be_valid
    account.save

    expect(account.reload.id).not_to be_nil
    expect(account).to be_valid
  end

  it "enforces email uniqueness at database level" do
    FactoryBot.create(:account, email: "email@gmail.com")
    account = FactoryBot.build(:account, email: "email@gmail.com")
    expect {
      account.save(validate: false)
    }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  describe ".mentors_pending_invites" do
    it "only includes mentors with pending team invites" do
      pending_mentor = FactoryBot.create(:mentor, :onboarded)
      accepted_mentor = FactoryBot.create(:mentor, :onboarded)
      declined_mentor = FactoryBot.create(:mentor, :onboarded)

      FactoryBot.create(:mentor, :onboarded)
      FactoryBot.create(:student)
      FactoryBot.create(:judge)
      FactoryBot.create(:ambassador)
      FactoryBot.create(:admin)

      FactoryBot.create(:mentor_invite, :pending, invitee: pending_mentor)
      FactoryBot.create(:mentor_invite, :accepted, invitee: accepted_mentor)
      FactoryBot.create(:mentor_invite, :declined, invitee: declined_mentor)

      expect(Account.mentors_pending_invites).to eq([pending_mentor.account])
    end
  end

  describe ".mentors_pending_requests" do
    it "only includes mentors with pending join requests" do
      pending_mentor = FactoryBot.create(:mentor, :onboarded)
      accepted_mentor = FactoryBot.create(:mentor, :onboarded)
      declined_mentor = FactoryBot.create(:mentor, :onboarded)

      FactoryBot.create(:mentor, :onboarded)
      FactoryBot.create(:student)
      FactoryBot.create(:judge)
      FactoryBot.create(:ambassador)
      FactoryBot.create(:admin)

      FactoryBot.create(:join_request, :pending, requestor: pending_mentor)
      FactoryBot.create(:join_request, :accepted, requestor: accepted_mentor)
      FactoryBot.create(:join_request, :declined, requestor: declined_mentor)

      expect(Account.mentors_pending_requests).to eq([pending_mentor.account])
    end
  end

  describe "regioning" do
    it "works with primary region searches" do
      FactoryBot.create(:account, :los_angeles)
      chi = FactoryBot.create(:account, :chicago)
      ra = FactoryBot.create(:ambassador, :chicago)

      expect(Account.in_region(ra)).to contain_exactly(chi, ra.account)
    end

    it "works with secondary region searches" do
      FactoryBot.create(:account, :brazil)
      la = FactoryBot.create(:account, :los_angeles)
      chi = FactoryBot.create(:account, :chicago)

      ra = FactoryBot.create(
        :ambassador,
        :chicago,
        secondary_regions: ["CA, US"])

      expect(Account.in_region(ra))
        .to contain_exactly(chi, la, ra.account)
    end
  end

  it "sets an auth token" do
    account = FactoryBot.create(:account)
    expect(account.auth_token).not_to be_blank
  end

  it "returns a NullTeams for accounts that can't be on teams" do
    %w{judge regional_ambassador}.each do |type|
      profile = FactoryBot.create(type)
      expect(profile.account.teams.current).to eq(Team.none)
    end
  end

  it "requires a secure password when invited" do
    FactoryBot.create(
      :team_member_invite,
      invitee_email: "test@account.com"
    )
    account = FactoryBot.build(
      :account,
      email: "test@account.com",
      password: "short"
    )
    expect(account).not_to be_valid
    expect(account.errors[:password]).to eq([
      "is too short (minimum is 8 characters)"
    ])
  end

  %i{mentor regional_ambassador}.each do |type|
    it "doesn't need a BG check outside of the US" do
      account = FactoryBot.create(type,
                                   city: "Salvador",
                                   state_province: "Bahia",
                                   country: "BR")
      expect(account).to be_background_check_complete
    end
  end

  it "calculates age" do
    account = FactoryBot.create(:account)

    account.date_of_birth = 15.years.ago + 1.day
    expect(account.age).to eq(14)

    account.date_of_birth = 15.years.ago
    expect(account.age).to eq(15)
  end

  it "calculates age compared to a particular date" do
    Timecop.freeze(Date.new(2017, 11, 29)) do
      account = FactoryBot.create(:account)

      account.date_of_birth = 15.years.ago + 3.months
      expect(account.age(3.months.from_now)).to eq(15)
    end
  end

  it "calculates age correctly during leap years" do
    account = FactoryBot.create(:account)
    account.date_of_birth = Date.new(2001, 3, 1)

    Timecop.freeze(Date.new(2016, 2, 29)) do
      expect(account.age).to eq(14)
    end

    Timecop.freeze(Date.new(2016, 3, 1)) do
      expect(account.age).to eq(15)
    end
  end

  it "calculates age correctly for leap year birthdays" do
    account = FactoryBot.create(:account)
    account.date_of_birth = Date.new(2000, 2, 29)

    Timecop.freeze(Date.new(2017, 2, 28)) do
      expect(account.age).to eq(16)
    end

    Timecop.freeze(Date.new(2017, 3, 1)) do
      expect(account.age).to eq(17)
    end
  end

  it "does a somewhat normal email validation" do
    account = FactoryBot.create(:account)

    account.skip_existing_password = true

    account.email = "hello@world.com"
    account.valid?
    expect(account.errors.keys).not_to include(:email)

    account.email = "hellono"
    account.valid?
    expect(account.errors.keys).to include(:email)

    account.email = "hello@world.com, hello@someone.com"
    account.valid?
    expect(account.errors.keys).to include(:email)
  end

  it "does not require a password for email case changing" do
    account = FactoryBot.build(:account, email: "caSE@change.COM")
    account.save(validate: false)

    account.reload

    expect(account.save).to be true
    expect(account.reload.email).to eq("case@change.com")
  end

  it "re-cache team_region_division_names as account gets added to new teams" do
    account = FactoryBot.create(:mentor, :onboarded).account
    expect(account.team_region_division_names).to be_empty

    account.teams << FactoryBot.create(:team)
    expect(account.team_region_division_names).to match_array(["US_IL,junior"])

    account.teams << FactoryBot.create(
      :team,
      city: "Los Angeles",
      state_province: "CA"
    )
    expect(account.team_region_division_names).to match_array(
      ["US_IL,junior",
       "US_CA,junior"]
    )
  end

  describe ".inactive_mentors" do
    it "pulls mentors with no new activities since 3 weeks ago" do
      active = FactoryBot.create(:mentor, :onboarded)
      inactive = FactoryBot.create(:mentor, :onboarded)

      active.activities.destroy_all
      inactive.activities.destroy_all

      active.account.create_activity({
        key: "account.update"
      })

      inactive.account.create_activity({
        key: "account.update",
        created_at: 22.days.ago
      })

      expect(Account.inactive_mentors).to eq([inactive.account])
    end
  end

  describe ".matched" do
    it "returns students with current teams" do
      judge = FactoryBot.create(:judge)
      unmatched_student = FactoryBot.create(:student)

      past_student = FactoryBot.create(:student, :on_team)
      past_student.team.update_column(
        :seasons,
        [Season.current.year - 1]
      )

      matched_student = FactoryBot.create(:student, :on_team)

      expect(Account.matched).to include(matched_student.account)

      expect(Account.matched).not_to include(judge.account)
      expect(Account.matched).not_to include(past_student.account)
      expect(Account.matched).not_to include(unmatched_student.account)
    end

    it "includes mentors with current teams" do
      unmatched_mentor = FactoryBot.create(:mentor, :onboarded)
      matched_mentor = FactoryBot.create(:mentor, :onboarded, :on_team)

      past_mentor = FactoryBot.create(:mentor, :onboarded, :on_team)

      past_mentor.teams.each do |team|
        team.update_column(:seasons, [Season.current.year - 1])
      end

      expect(Account.matched).to include(matched_mentor.account)

      expect(Account.matched).not_to include(unmatched_mentor.account)
      expect(Account.matched).not_to include(past_mentor.account)
    end
  end

  describe ".unmatched" do
    it "returns students without current teams" do
      judge = FactoryBot.create(:judge)
      unmatched_student = FactoryBot.create(:student)

      past_student = FactoryBot.create(:student, :on_team)
      past_student.team.update_column(
        :seasons,
        [Season.current.year - 1]
      )

      matched_student = FactoryBot.create(:student, :on_team)

      expect(Account.unmatched).to include(past_student.account)
      expect(Account.unmatched).to include(unmatched_student.account)

      expect(Account.unmatched).not_to include(matched_student.account)
      expect(Account.unmatched).not_to include(judge.account)
    end

    it "includes mentors without current teams" do
      unmatched_mentor = FactoryBot.create(:mentor, :onboarded)
      matched_mentor = FactoryBot.create(:mentor, :onboarded, :on_team)

      past_mentor = FactoryBot.create(:mentor, :onboarded, :on_team)

      past_mentor.teams.each do |team|
        team.update_column(:seasons, [Season.current.year - 1])
      end

      expect(Account.unmatched).to include(unmatched_mentor.account)
      expect(Account.unmatched).to include(past_mentor.account)

      expect(Account.unmatched).not_to include(matched_mentor.account)
    end

    it "excludes mentors with past teams and current teams" do
      mentor = FactoryBot.create(:mentor, :onboarded, :on_team)

      past_team = FactoryBot.create(:team, members_count: 0)
      past_team.update_column(:seasons, [Season.current.year - 1])
      TeamRosterManaging.add(past_team, mentor)

      expect(Account.unmatched).to be_empty
    end

    it "excludes students with past teams and current teams" do
      student = FactoryBot.create(:student, :on_team)

      past_team = FactoryBot.create(:team, members_count: 0)
      past_team.update_column(:seasons, [Season.current.year - 1])
      TeamRosterManaging.add(past_team, student)

      expect(Account.unmatched).not_to include(student)
    end

    it "excludes students and mentors with current teams" do
      mentor = FactoryBot.create(:mentor, :onboarded, :on_team)
      student = FactoryBot.create(:student, :on_team)

      team = FactoryBot.create(:team, members_count: 0)
      TeamRosterManaging.add(team, [mentor, student])

      expect(Account.unmatched).not_to include(student)
      expect(Account.unmatched).not_to include(mentor)
    end
  end

  describe ".parental_consented" do
    it "returns students with current signed parental consents" do
      judge = FactoryBot.create(:judge)
      mentor = FactoryBot.create(:mentor, :onboarded)
      ra = FactoryBot.create(:ambassador)

      unconsented_student = FactoryBot.create(:onboarding_student)

      past_consented_student = FactoryBot.create(:onboarded_student)
      past_consented_student.account.update(
        seasons: [Season.current.year - 1]
      )
      past_consented_student.parental_consent.update(
        seasons: [Season.current.year - 1]
      )

      consented_student = FactoryBot.create(:onboarded_student)

      expect(Account.parental_consented).to include(consented_student.account)

      expect(Account.parental_consented).not_to include(judge.account)
      expect(Account.parental_consented).not_to include(mentor.account)
      expect(Account.parental_consented).not_to include(ra.account)

      expect(Account.parental_consented).not_to include(past_consented_student.account)
      expect(Account.parental_consented).not_to include(unconsented_student.account)
    end

    it "returns students by season with signed parental consents" do
      judge = FactoryBot.create(:judge)
      mentor = FactoryBot.create(:mentor, :onboarded)
      ra = FactoryBot.create(:ambassador)

      unconsented_student = FactoryBot.create(:onboarding_student)

      past_consented_student = FactoryBot.create(:onboarded_student)
      past_consented_student.account.update(
        seasons: [Season.current.year - 1]
      )
      past_consented_student.parental_consent.update(
        seasons: [Season.current.year - 1]
      )

      past_unconsented_student = FactoryBot.create(:onboarded_student)
      past_unconsented_student.account.update(
        seasons: [Season.current.year - 1]
      )
      past_unconsented_student.parental_consent.update(
        seasons: [Season.current.year - 1],
        status: :pending
      )

      consented_student = FactoryBot.create(:onboarded_student)

      results = Account.parental_consented(Season.current.year - 1)

      expect(results).to include(past_consented_student.account)

      expect(results).not_to include(judge.account)
      expect(results).not_to include(mentor.account)
      expect(results).not_to include(ra.account)

      expect(results).not_to include(consented_student.account)
      expect(results).not_to include(unconsented_student.account)
      expect(results).not_to include(past_unconsented_student.account)
    end
  end

  describe ".not_parental_consented" do
    it "returns current students without signed parental consents" do
      judge = FactoryBot.create(:judge)
      mentor = FactoryBot.create(:mentor, :onboarded)
      ra = FactoryBot.create(:ambassador)

      unconsented_student = FactoryBot.create(:onboarding_student)

      past_consented_student = FactoryBot.create(:onboarded_student)
      past_consented_student.account.update(
        seasons: [Season.current.year - 1]
      )
      past_consented_student.parental_consent.update(
        seasons: [Season.current.year - 1]
      )

      past_unconsented_student = FactoryBot.create(:onboarding_student)
      account = past_unconsented_student.account
      account.update(
        seasons: [Season.current.year - 1]
      )

      consented_student = FactoryBot.create(:onboarded_student)

      results = Account.not_parental_consented
      expect(results).to include(unconsented_student.account)

      expect(results).not_to include(judge.account)
      expect(results).not_to include(mentor.account)
      expect(results).not_to include(ra.account)

      expect(results).not_to include(consented_student.account)
      expect(results).not_to include(past_consented_student.account)
      expect(results.current.pluck(:email)).not_to include(
        past_unconsented_student.account.email
      )
    end

    it "returns students by season without signed parental consents" do
      judge = FactoryBot.create(:judge)
      mentor = FactoryBot.create(:mentor, :onboarded)
      ra = FactoryBot.create(:ambassador)

      unconsented_student = FactoryBot.create(:onboarding_student)

      past_consented_student = FactoryBot.create(:onboarded_student)
      past_consented_student.account.update(
        seasons: [Season.current.year - 1]
      )
      past_consented_student.parental_consent.update(
        seasons: [Season.current.year - 1]
      )

      past_unconsented_student = FactoryBot.create(:onboarded_student)
      past_unconsented_student.account.update(
        seasons: [Season.current.year - 1]
      )
      past_unconsented_student.parental_consent.update(
        seasons: [Season.current.year - 1],
        status: :pending
      )

      FactoryBot.create(:onboarded_student)
        # consented student

      results = Account.not_parental_consented(Season.current.year - 1)

      expect(results).to include(past_unconsented_student.account)

      expect(results).not_to include(judge.account)
      expect(results).not_to include(mentor.account)
      expect(results).not_to include(ra.account)

      expect(results).not_to include(past_consented_student.account)
      expect(results).not_to include(unconsented_student.account)
    end
  end

  describe ".returning?" do
    it "returns true if an account has multiple seasons" do
      returning_account = FactoryBot.create(:account, :returning)

      expect(returning_account.returning?).to be true
    end

    it "returns false if an account does not have multiple seasons" do
      new_account = FactoryBot.create(:account)

      expect(new_account.returning?).to be false
    end
  end

  describe ".onboarded_mentors" do
    it "includes onboarded mentor" do
      profile = FactoryBot.create(:mentor, :onboarded)
      expect(Account.onboarded_mentors).to include(profile.account)
      expect(profile.reload).to be_onboarded
    end

    it "excludes not a mentor" do
      student = FactoryBot.create(:student, :onboarded).account
      expect(Account.onboarded_mentors).not_to include(student)
    end

    it "excludes unconfirmed email" do
      profile = FactoryBot.create(:mentor, :onboarded)
      profile.account.update_column(:email_confirmed_at, nil)

      expect(Account.onboarded_mentors).not_to include(profile.account)
    end

    it "excludes incomplete bio" do
      profile = FactoryBot.create(:mentor, :onboarded)
      profile.bio = nil
      profile.save

      expect(Account.onboarded_mentors).not_to include(profile.account)

      profile.bio = ""
      profile.save

      expect(Account.onboarded_mentors).not_to include(profile.account)
    end

    it "excludes incomplete training" do
      profile = FactoryBot.create(:mentor, :onboarded)
      profile.training_completed_at = nil
      profile.save

      expect(Account.onboarded_mentors).not_to include(profile.account)
    end

    it "includes training not required" do
      profile = FactoryBot.create(:mentor, :onboarded)
      profile.update_column(:training_completed_at, nil)
      profile.account.update_column(:season_registered_at, ImportantDates.mentor_training_required_since - 1.day)

      expect(Account.onboarded_mentors).to include(profile.account)
      expect(profile.reload).to be_onboarded
    end

    it "excludes US without clear background check" do
      profile = FactoryBot.create(:mentor, :onboarded)
      profile.account.background_check.destroy!

      expect(Account.onboarded_mentors).not_to include(profile.account)
    end

    it "includes international without background check" do
      profile = FactoryBot.create(:mentor, :onboarded, :brazil)

      expect(profile.account.background_check).to be_instance_of(NullBackgroundCheck)
      expect(Account.onboarded_mentors).to include(profile.account)
      expect(profile.reload).to be_onboarded
    end

    it "excludes consent not signed" do
      profile = FactoryBot.create(:mentor, :onboarded)
      profile.consent_waiver.void!

      expect(Account.onboarded_mentors).not_to include(profile.account)

      profile.void_consent_waivers.destroy_all
      profile.reload

      expect(profile.consent_waiver).to be_instance_of(NullConsentWaiver)
      expect(Account.onboarded_mentors).not_to include(profile.account)
    end

    it "excludes type not set" do
      profile = FactoryBot.create(:mentor, :onboarded)
      profile.update_column(:mentor_type, nil)

      expect(Account.onboarded_mentors).not_to include(profile.account)
    end
  end

  describe ".onboarding_mentors" do
    it "excludes onboarded mentor" do
      profile = FactoryBot.create(:mentor, :onboarded)
      expect(Account.onboarding_mentors).not_to include(profile.account)
    end

    it "excludes not a mentor" do
      student = FactoryBot.create(:student, :onboarded).account
      expect(Account.onboarding_mentors).not_to include(student)
    end

    it "includes unconfirmed email" do
      profile = FactoryBot.create(:mentor, :onboarded)
      profile.account.update_column(:email_confirmed_at, nil)

      expect(Account.onboarding_mentors).to include(profile.account)
      expect(profile.reload).not_to be_onboarded
    end

    it "includes incomplete bio" do
      profile = FactoryBot.create(:mentor, :onboarded)
      profile.bio = nil
      profile.save

      expect(Account.onboarding_mentors).to include(profile.account)
      expect(profile.reload).not_to be_onboarded

      profile.bio = ""
      profile.save

      expect(Account.onboarding_mentors).to include(profile.account)
      expect(profile.reload).not_to be_onboarded
    end

    it "includes incomplete training" do
      profile = FactoryBot.create(:mentor, :onboarded)
      profile.training_completed_at = nil
      profile.save

      expect(Account.onboarding_mentors).to include(profile.account)
      expect(profile.reload).not_to be_onboarded
    end

    it "excludes training not required" do
      profile = FactoryBot.create(:mentor, :onboarded)
      profile.update_column(:training_completed_at, nil)
      profile.account.update_column(:season_registered_at, ImportantDates.mentor_training_required_since - 1.day)

      expect(Account.onboarding_mentors).not_to include(profile.account)
    end

    it "includes US without clear background check" do
      profile = FactoryBot.create(:mentor, :onboarded)
      profile.account.background_check.update_column(:status, :pending)

      expect(Account.onboarding_mentors).to include(profile.account)
      expect(profile.reload).not_to be_onboarded

      profile.account.background_check.destroy!

      expect(Account.onboarding_mentors).to include(profile.account)
      expect(profile.reload).not_to be_onboarded
    end

    it "excludes international without background check" do
      profile = FactoryBot.create(:mentor, :onboarded, :brazil)

      expect(profile.account.background_check).to be_instance_of(NullBackgroundCheck)
      expect(Account.onboarding_mentors).not_to include(profile.account)
    end

    it "includes consent not signed" do
      profile = FactoryBot.create(:mentor, :onboarded)
      profile.consent_waiver.void!

      expect(Account.onboarding_mentors).to include(profile.account)
      expect(profile.reload).not_to be_onboarded

      profile.void_consent_waivers.destroy_all
      profile.reload

      expect(profile.consent_waiver).to be_instance_of(NullConsentWaiver)
      expect(Account.onboarding_mentors).to include(profile.account)
      expect(profile.reload).not_to be_onboarded
    end

    it "includes type not set" do
      profile = FactoryBot.create(:mentor, :onboarded)
      profile.update_column(:mentor_type, nil)

      expect(Account.onboarding_mentors).to include(profile.account)
      expect(profile.reload).not_to be_onboarded
    end
  end

  describe "#can_switch_to_judge?" do
    describe "when config is off" do
      before do
        allow(ENV).to receive(:fetch).and_call_original
        allow(ENV).to receive(:fetch).with("ENABLE_SWITCH_BETWEEN_JUDGE_AND_MENTOR", any_args).and_return(false)
        allow(ENV).to receive(:fetch).with("ENABLE_RA_SWITCH_TO_JUDGE", any_args).and_return(false)
      end

      it "allows no one" do
        expect(FactoryBot.create(:student).can_switch_to_judge?).to be false
        expect(FactoryBot.create(:mentor).can_switch_to_judge?).to be false
        expect(FactoryBot.create(:regional_ambassador).can_switch_to_judge?).to be false
      end
    end

    describe "when mentor config is on" do
      before do
        allow(ENV).to receive(:fetch).and_call_original
        allow(ENV).to receive(:fetch).with("ENABLE_SWITCH_BETWEEN_JUDGE_AND_MENTOR", any_args).and_return(1)
        allow(ENV).to receive(:fetch).with("ENABLE_RA_SWITCH_TO_JUDGE", any_args).and_return(false)
      end

      it "allows only mentors" do
        expect(FactoryBot.create(:student).can_switch_to_judge?).to be false
        expect(FactoryBot.create(:mentor).can_switch_to_judge?).to be true
        expect(FactoryBot.create(:regional_ambassador).can_switch_to_judge?).to be false
      end
    end

    describe "when RA config is on" do
      before do
        allow(ENV).to receive(:fetch).and_call_original
        allow(ENV).to receive(:fetch).with("ENABLE_SWITCH_BETWEEN_JUDGE_AND_MENTOR", any_args).and_return(false)
        allow(ENV).to receive(:fetch).with("ENABLE_RA_SWITCH_TO_JUDGE", any_args).and_return(1)
      end

      it "allows RAs with judge profiles" do
        expect(FactoryBot.create(:student).can_switch_to_judge?).to be false
        expect(FactoryBot.create(:mentor).can_switch_to_judge?).to be false
        expect(FactoryBot.create(:regional_ambassador).can_switch_to_judge?).to be false
        expect(FactoryBot.create(:regional_ambassador, :has_judge_profile).can_switch_to_judge?).to be true
      end
    end
  end

  describe "#can_switch_to_mentor?" do
    describe "when config is off" do
      before do
        allow(ENV).to receive(:fetch).and_call_original
        allow(ENV).to receive(:fetch).with("ENABLE_SWITCH_BETWEEN_JUDGE_AND_MENTOR", any_args).and_return(false)
      end

      it "allows RAs" do
        expect(FactoryBot.create(:student).can_switch_to_mentor?).to be false
        expect(FactoryBot.create(:judge).can_switch_to_mentor?).to be false
        expect(FactoryBot.create(:regional_ambassador).can_switch_to_mentor?).to be true
      end
    end

    describe "when mentor config is on" do
      before do
        allow(ENV).to receive(:fetch).and_call_original
        allow(ENV).to receive(:fetch).with("ENABLE_SWITCH_BETWEEN_JUDGE_AND_MENTOR", any_args).and_return(1)
      end

      it "allows judges and RAs" do
        expect(FactoryBot.create(:student).can_switch_to_mentor?).to be false
        expect(FactoryBot.create(:judge).can_switch_to_mentor?).to be true
        expect(FactoryBot.create(:regional_ambassador).can_switch_to_mentor?).to be true
      end
    end
  end
end
