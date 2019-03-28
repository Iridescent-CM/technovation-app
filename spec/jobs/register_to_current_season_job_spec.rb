require "rails_helper"

RSpec.describe RegisterToCurrentSeasonJob do
  %w{judge student mentor}.each do |scope|
    it "subscribes a #{scope} to the #{scope} newsletter" do
      profile = FactoryBot.create(scope)

      profile.account.update(seasons: [])

      expect(SubscribeEmailListJob).to receive(:perform_later).with(
        profile.email,
        profile.name,
        "#{scope.upcase}_LIST_ID",
        any_args,
      )

      RegisterToCurrentSeasonJob.perform_now(profile.account)
    end
  end

  it "welcomes students" do
    student = FactoryBot.create(:student)

    student.account.update(
      seasons: [],
    )

    mailer = double(:RegistrationMailer, deliver_later: true)

    expect(RegistrationMailer).to receive(:welcome_student)
      .with(student.account)
      .and_return(mailer)

    expect(mailer).to receive(:deliver_later)

    RegisterToCurrentSeasonJob.perform_now(student.account)
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