require "rails_helper"

RSpec.describe RegisterToCurrentSeasonJob do
  %w{judge student mentor}.each do |scope|
    it "subscribes a #{scope} to the #{scope} newsletter" do
      profile = FactoryBot.create(scope)

      profile.account.update(seasons: [])

      expect(SubscribeAccountToEmailListJob).to receive(:perform_later).with(
        account_id: profile.account.id,
        profile_type: scope
      )

      RegisterToCurrentSeasonJob.perform_now(profile.account)
    end

    it "resets #{scope} onboarded status if necessary" do
      profile = nil

      Timecop.freeze(ImportantDates.new_season_switch - 1.day) do
        profile = FactoryBot.create(scope, :onboarded)
      end

      expect {
        Timecop.freeze(ImportantDates.new_season_switch + 1.day) do
          ConsentWaiver.nonvoid.find_each(&:void!) # see lib/tasks/reset_consents.rake
          RegisterToCurrentSeasonJob.perform_now(profile.account)
        end
      }.to change {
        profile.reload.onboarded?
      }.from(true).to(false)
    end
  end

  context "students" do
    context "welcome student emails" do
      let(:registration_mailer) { double(RegistrationMailer, deliver_later: true) }

      before do
        student.account.update(seasons: [])
      end

      context "when it's a senior student" do
        let(:student) { FactoryBot.create(:student, :senior) }

        it "sends the 'welcome_student' email" do
          expect(RegistrationMailer).to receive(:welcome_student)
            .with(student.account)
            .and_return(registration_mailer)

          expect(registration_mailer).to receive(:deliver_later)

          RegisterToCurrentSeasonJob.perform_now(student.account)
        end
      end

      context "when it's a junior student" do
        let(:student) { FactoryBot.create(:student, :junior) }

        it "sends the 'welcome_student' email" do
          expect(RegistrationMailer).to receive(:welcome_student)
            .with(student.account)
            .and_return(registration_mailer)

          expect(registration_mailer).to receive(:deliver_later)

          RegisterToCurrentSeasonJob.perform_now(student.account)
        end
      end

      context "when it's a beginner student" do
        let(:student) { FactoryBot.create(:student, :beginner) }

        it "sends the 'welcome_parent' email" do
          expect(RegistrationMailer).to receive(:welcome_parent)
            .with(student.account)
            .and_return(registration_mailer)

          expect(registration_mailer).to receive(:deliver_later)

          RegisterToCurrentSeasonJob.perform_now(student.account)
        end
      end
    end

    it "creates unsigned parental consents for students" do
      student = FactoryBot.create(:student)

      student.account.update(
        seasons: [],
      )

      student.parental_consents.destroy_all

      expect {
        RegisterToCurrentSeasonJob.perform_now(student.account)
      }.to change {
        student.parental_consents.unsigned.count
      }.from(0).to(1)
    end

    it "creates a new media consent for students" do
      student = FactoryBot.create(:student)

      student.account.update(
        seasons: []
      )

      expect {
        RegisterToCurrentSeasonJob.perform_now(student.account)
      }.to change {
        student.media_consents.count
      }.from(0).to(1)
    end

    it "emails parents of returning students" do
      student = FactoryBot.create(
        :student,
        :past,
        parent_guardian_email: "something@exists.com"
      )

      mailer = double(:ParentMailer, deliver_later: true)

      expect(ParentMailer).to receive(:consent_notice)
        .with(student.id)
        .and_return(mailer)

      expect(mailer).to receive(:deliver_later)

      RegisterToCurrentSeasonJob.perform_now(student.reload.account)
    end
  end

  context "students who are now mentors" do
    let(:account) { FactoryBot.create(:account) }
    let!(:student) { FactoryBot.create(:student, account: account) }
    let!(:mentor) { FactoryBot.create(:mentor, account: account) }
    let(:welcome_student_email) { double("welcome student email") }
    let(:parental_consent_notice_email) { double("parental consent notice email") }

    before do
      allow(RegistrationMailer).to receive(:welcome_student)
        .with(account)
        .and_return(welcome_student_email)

      allow(ParentMailer).to receive(:consent_notice)
        .with(student.id)
        .and_return(parental_consent_notice_email)
    end

    it "does not send a student welcome email" do
      expect(welcome_student_email).not_to receive(:deliver_later)

      RegisterToCurrentSeasonJob.perform_now(account)
    end

    it "does not send a parental consent notice email" do
      expect(parental_consent_notice_email).not_to receive(:deliver_later)

      RegisterToCurrentSeasonJob.perform_now(account)
    end
  end

  context "mentors" do
    it "resets mentor training" do
      profile = nil

      Timecop.freeze(ImportantDates.new_season_switch - 1.day) do
        profile = FactoryBot.create(:mentor, :onboarded)
      end

      expect {
        Timecop.freeze(ImportantDates.new_season_switch + 1.day) do
          RegisterToCurrentSeasonJob.perform_now(profile.account)
        end
      }.to change {
        profile.reload.training_complete?
      }.from(true).to(false)
    end
  end

  it "resets judge training" do
    profile = nil

    Timecop.freeze(ImportantDates.new_season_switch - 1.day) do
      profile = FactoryBot.create(:judge, :onboarded)
    end

    expect {
      Timecop.freeze(ImportantDates.new_season_switch + 1.day) do
        RegisterToCurrentSeasonJob.perform_now(profile.account)
      end
    }.to change {
      profile.reload.training_completed?
    }.from(true).to(false)
  end

  it "records activity" do
    student = FactoryBot.create(:student)

    student.account.update(
      seasons: [],
    )

    student.activities.destroy_all

    expect {
      RegisterToCurrentSeasonJob.perform_now(student.account)
    }.to change {
      student.activities.count
    }.from(0).to(1)

    expect(student.activities.last.key).to eq("account.register_current_season")
  end

  it "skips records with the current season" do
    student = FactoryBot.create(:student)

    student.account.update(
      seasons: [Season.current.year],
    )

    expect {
      RegisterToCurrentSeasonJob.perform_now(student.account)
    }.not_to change {
      student.season_registered_at
    }
  end

  it "updates the season registered at datetime" do
    student = FactoryBot.create(:student)

    student.account.update(
      seasons: [],
    )

    expect {
      RegisterToCurrentSeasonJob.perform_now(student.account)
    }.to change {
      student.season_registered_at
    }
  end

end
