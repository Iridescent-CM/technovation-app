require 'factory_bot'

desc "Seed QA with test judge data for badges / certificates"
task seed_test_judges: :environment do
  def log(msg)
    puts "============================================================="
    puts ""
    puts msg
    puts ""
    puts "============================================================="
  end

  Account.with_deleted.where(email: ["virtual@judge-advisor.com", "live@judge-advisor.com"])
    .each(&:really_destroy!)

  Team.with_deleted.where("name like 'Virtual GrrlPower%' OR name like 'Live GrrlPower%'")
    .each(&:really_destroy!)

  if event = RegionalPitchEvent.find_by(name: "Seeded Advisor Event")
    event.destroy
  end

  virtual_judge = JudgeProfile.create!(
    account_attributes: {
      email: "virtual@judge-advisor.com",
      email_confirmed_at: Time.current,
      password: "virtual@judge-advisor.com",
      first_name: "Gabe",
      last_name: "Lewis",
      date_of_birth: Date.today - 34.years,
      city: "Evanston",
      state_province: "IL",
      country: "US",
      seasons: [Season.current.year],
    },
    company_name: "Sabre",
    job_title: "Corp. Branch Liason",
  )

  virtual_judge.account.update_column(:profile_image, "foo/bar/baz.png")
  virtual_judge.account.create_consent_waiver!(FactoryBot.attributes_for(:consent_waiver))

  log "Created Judge: #{virtual_judge.email} with password #{virtual_judge.email}"

  live_judge = JudgeProfile.create!(
    account_attributes: {
      email: "live@judge-advisor.com",
      email_confirmed_at: Time.current,
      password: "live@judge-advisor.com",
      first_name: "Bob",
      last_name: "Kaczimakis",
      date_of_birth: Date.today - 34.years,
      city: "Evanston",
      state_province: "IL",
      country: "US",
      seasons: [Season.current.year],
    },
    company_name: "Sabre",
    job_title: "CEO",
  )

  live_judge.account.update_column(:profile_image, "foo/bar/baz.png")
  live_judge.account.create_consent_waiver!(FactoryBot.attributes_for(:consent_waiver))

  log "Created Judge: #{live_judge.email} with password #{live_judge.email}"

  event = RegionalPitchEvent.create!(
    name: "Seeded Advisor Event",
    starts_at: Time.current - 200.hours,
    ends_at: Time.current - 195.hours,
    division_ids: Division.pluck(:id),
    city: "Chicago",
    venue_address: "100 N. LaSalle",
    ambassador: ChapterAmbassadorProfile.all.sample,
  )

  live_judge.events << event

  log "Added live judge to regional pitch event"

  Array(1..11).each do |n|
    team = Team.create!(name: "Virtual GrrlPower#{n}", division: Division.junior)
    team.create_submission!(FactoryBot.attributes_for(:submission, :complete))

    log "Created Team #{team.name} with submission #{team.submission.app_name}"

    score = SubmissionScore.create!(
      judge_profile: virtual_judge,
      team_submission: team.submission,
    )

    score.complete!

    log "Created score for #{team.name} and #{virtual_judge.email}"
  end

  Array(1..11).each do |n|
    team = Team.create!(name: "Live GrrlPower#{n}", division: Division.junior)
    team.create_submission!(FactoryBot.attributes_for(:submission, :complete))

    log "Created Team #{team.name} with submission #{team.submission.app_name}"

    team.events << event

    log "Added team #{team.name} to regional pitch event"

    score = SubmissionScore.create!(
      judge_profile: live_judge,
      team_submission: team.submission,
    )

    score.complete!

    log "Created score for #{team.name} and #{virtual_judge.email}"
  end

  if live_judge.judge_profile.current_quarterfinals_complete_scores.count != 11
    raise "Problem with seed data, live judge doesn't have 11 completed QF scores"
  end

  if virtual_judge.judge_profile.current_quarterfinals_complete_scores.count != 11
    raise "Problem with seed data, virtual judge doesn't have 11 completed QF scores"
  end
end
