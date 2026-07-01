require "factory_bot"

desc "Seed 100 complete submissions (virtual and live) with varied quarterfinals official score counts"
task seed_test_submissions: :environment do
  PREFIX = "Seeded Scores Submission"
  COUNT = Integer(ENV.fetch("COUNT", 100))
  VIRTUAL_COUNT = COUNT / 2
  LIVE_COUNT = COUNT - VIRTUAL_COUNT
  SCORE_COUNTS = (0..5).to_a
  SEED_CITY = "Chicago"
  SEED_STATE = "IL"
  SEED_COUNTRY = "US"

  def log(msg)
    puts msg
  end

  def publish_complete_submission!(submission)
    submission.update_columns(
      source_code: "source_code.zip",
      business_plan: "business_plan.pdf",
      bibliography: "bibliography.pdf",
      pitch_presentation: "slides.pdf"
    )
    2.times { submission.screenshots.create! }
    submission.reload.published!
  end

  def seed_student_for_team!(team, number)
    email = "seeded-scores-student-#{format('%03d', number)}@example.com"
    student = Account.find_by(email: email)&.student_profile

    unless student
      student = StudentProfile.create!(
        school_name: "Seed High",
        parent_guardian_email: "seeded-scores-parent-#{format('%03d', number)}@example.com",
        parent_guardian_name: "Parent Name",
        account_attributes: {
          email: email,
          password: email,
          first_name: "Seed",
          last_name: "Student #{number}",
          date_of_birth: Date.today - 14.years,
          city: SEED_CITY,
          state_province: SEED_STATE,
          country: SEED_COUNTRY,
          email_confirmed_at: Time.current,
          seasons: [Season.current.year]
        }
      )
      student.create_parental_consent!(
        FactoryBot.attributes_for(:parental_consent, :signed)
      )
    end

    TeamRosterManaging.add(team, student) unless team.students.include?(student)
    team.reload
  end

  Team.with_deleted.where("name LIKE ?", "#{PREFIX}%").find_each(&:really_destroy!)

  if (event = RegionalPitchEvent.find_by(name: "#{PREFIX} Live Event"))
    event.destroy
  end

  ambassador = ChapterAmbassadorProfile.first
  if ambassador.nil?
    abort "No ChapterAmbassadorProfile found — create one before running this task."
  end

  live_event = RegionalPitchEvent.create!(
    name: "#{PREFIX} Live Event",
    starts_at: ImportantDates.rpe_start_date,
    ends_at: ImportantDates.rpe_start_date + 1.day,
    division_id: Division.junior.id,
    city: SEED_CITY,
    venue_address: "100 N. LaSalle",
    ambassador: ambassador
  )

  log "Creating #{VIRTUAL_COUNT} virtual and #{LIVE_COUNT} live complete submissions..."

  COUNT.times do |index|
    number = index + 1
    live = index >= VIRTUAL_COUNT
    score_count = SCORE_COUNTS[index % SCORE_COUNTS.length]

    team = Team.create!(
      name: "#{PREFIX} #{format('%03d', number)}",
      division: Division.junior,
      city: SEED_CITY,
      state_province: SEED_STATE,
      country: SEED_COUNTRY
    )
    seed_student_for_team!(team, number)
    submission = team.create_submission!(
      FactoryBot.attributes_for(:submission, :complete)
    )
    publish_complete_submission!(submission)

    team.events << live_event if live

    submission.update_column(
      :complete_quarterfinals_official_submission_scores_count,
      score_count
    )

    kind = live ? "live" : "virtual"
    log "  #{number}/#{COUNT} #{kind} submission ##{submission.id} — #{score_count} complete official QF scores"
  end

  seeded = TeamSubmission.current.joins(:team).where("teams.name LIKE ?", "#{PREFIX}%")

  log ""
  log "Done. Created #{seeded.count} submissions:"
  log "  Virtual: #{seeded.merge(TeamSubmission.virtual).count} (admin quarterfinals scope applies to these)"
  log "  Live:    #{seeded.merge(TeamSubmission.live).count}"
  log ""
  log "Score count distribution (complete_quarterfinals_official_submission_scores_count):"
  SCORE_COUNTS.each do |count|
    total = seeded.where(complete_quarterfinals_official_submission_scores_count: count).count
    log "  #{count}: #{total}" if total.positive?
  end
end
