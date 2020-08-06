require 'factory_bot_rails'

ActionMailer::Base.perform_deliveries = false

student = Account.find_by(email: "student@student.com").try(:student_profile)
student_team = Team.find_by(name: "All Star Team")
mentor = Account.find_by(email: "mentor@mentor.com").try(:mentor_profile)

if (student = StudentProfile.create(school_name: "John Hughes High",
                                    parent_guardian_email: "parent@parent.com",
                                    parent_guardian_name: "Parent Name",
                                    account_attributes: {
                                      email: "student@student.com",
                                      password: "student@student.com",
                                      first_name: "Clarissa",
                                      last_name: "McGee",
                                      date_of_birth: Date.today - 14.years,
                                      city: "Chicago",
                                      state_province: "IL",
                                      country: "US",
                                      email_confirmed_at: Time.current,
                                      seasons: [Season.current.year],
                                    })).valid?
  Geocoding.perform(student).with_save
  student.create_parental_consent!(FactoryBot.attributes_for(:parental_consent, :signed))
  puts ""
  puts "============================================================="
  puts ""
  puts "Created Student: #{student.email} with password #{student.email}"
  puts ""
  puts "============================================================="
  puts ""
else
  student = Account.find_by(email: "student@student.com").try(:student_profile)
end

if student and student.team.nil?
  if (
    student_team = Team.create(name: "All Star Team",
                        description: "We are allstars",
                        seasons: [Season.current.year],
                        division: Division.none_assigned_yet,
                        city: "Chicago",
                        state_province: "IL",
                        country: "US",
  )).valid?
    Geocoding.perform(student_team).with_save
    TeamRosterManaging.add(student_team, student)
    puts "Added student to Team: #{student_team.name}"
    puts ""
    puts "============================================================="
    puts ""
  else
    student_team = Team.find_by(name: "All Star Team")
    RegisterToCurrentSeasonJob.perform_now(student_team)
    TeamRosterManaging.add(student_team, student)
    puts "Added student to Team: #{student_team.name}"
    puts ""
    puts "============================================================="
    puts ""
  end
end

if (student = StudentProfile.create(school_name: "John Hughes High",
                                    parent_guardian_email: "joe+parent@joesak.com",
                                    parent_guardian_name: "Parent Name",
                                    account_attributes: {
                                      email: "past@student.com",
                                      password: "past@student.com",
                                      first_name: "Past",
                                      last_name: "Student",
                                      date_of_birth: Date.today - 14.years,
                                      city: "Chicago",
                                      state_province: "IL",
                                      country: "US",
                                      email_confirmed_at: Time.current,
                                      seasons: [Season.current.year - 1],
                                    })).valid?
  puts ""
  puts "============================================================="
  puts ""
  puts "Created #{student.seasons} Student: #{student.email} with password #{student.email}"
  puts ""
  puts "============================================================="
  puts ""
end

if (student = StudentProfile.create(school_name: "John Hughes High",
                                    parent_guardian_email: "parent@parent.com",
                                    parent_guardian_name: "Parent Name",
                                    account_attributes: {
                                      email: "distantpast@student.com",
                                      password: "distantpast@student.com",
                                      first_name: "Distant Past",
                                      last_name: "Student",
                                      date_of_birth: Date.today - 14.years,
                                      city: "Chicago",
                                      state_province: "IL",
                                      country: "US",
                                      email_confirmed_at: Time.current,
                                      seasons: [Season.current.year - 2],
                                    })).valid?
  student.create_parental_consent!(FactoryBot.attributes_for(:parental_consent, :signed))
  puts ""
  puts "============================================================="
  puts ""
  puts "Created #{student.seasons} Student: #{student.email} with password #{student.email}"
  puts ""
  puts "============================================================="
  puts ""
end

if (mentor = MentorProfile.create(
    account_attributes: {
      email: "mentor@mentor.com",
      password: "mentor@mentor.com",
      first_name: "Tom",
      last_name: "McGee",
      gender: "Male",
      date_of_birth: Date.today - 34.years,
      city: "Boulder",
      state_province: "CO",
      country: "US",
      email_confirmed_at: Time.current,
      seasons: [Season.current.year],

      background_check_attributes: {
        candidate_id: "SEEDED!",
        report_id: "SEEDED!",
        status: "clear",
      },
    },
    school_company_name: "Boeing",
    job_title: "Aerospace Engineer",
    expertise_ids: Expertise.pluck(:id)[0..1],
    bio: "Cool Colorado mentor with an adequate length of a bio. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    mentor_type: "Industry professional",
  )).valid?
  puts "Created Mentor: #{mentor.email} with password #{mentor.email}"
  puts ""
  puts "============================================================="
  puts ""
elsif mentor = Account.find_by(email: "mentor@mentor.com").try(:mentor_profile)
  puts "Found seeded mentor #{mentor.email}"
  puts ""
  puts "============================================================="
  puts ""
else
  puts "Could not find or create seeded mentor mentor@mentor.com"
  puts ""
  puts "============================================================="
  puts ""
end

if mentor
  if (
    team = Team.create(name: "Fun Times Team",
                       description: "We are fun times havers",
                       division: Division.none_assigned_yet,
                       seasons: [Season.current.year],
                       city: "Boulder",
                       state_province: "CO",
                       country: "US",
  )).valid?
    Geocoding.perform(team).with_save
    TeamRosterManaging.add(team, mentor)
    puts "Added mentor to Team: #{team.name}"
    puts ""
    puts "============================================================="
    puts ""
  end
end

if (mentor = MentorProfile.create(
    account_attributes: {
      email: "mentor+chi@mentor.com",
      password: "mentor+chi@mentor.com",
      email_confirmed_at: Time.current,
      seasons: [Season.current.year],

      background_check_attributes: {
        candidate_id: "SEEDED!",
        report_id: "SEEDED!",
        status: "clear",
      },

      first_name: "Joe",
      last_name: "McGee",
      gender: "Male",
      date_of_birth: Date.today - 34.years,
      city: "Evanston",
      state_province: "IL",
      country: "US",
    },

    school_company_name: "Boeing",
    job_title: "Aerospace Engineer",
    expertise_ids: Expertise.pluck(:id)[0..1],
    bio: "Cool chicago mentor with an adequate length of a bio. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    mentor_type: "Industry professional",
  )).valid?
  mentor.account.update_column(:profile_image, "foo/bar/baz.png")
  mentor.account.create_consent_waiver!(FactoryBot.attributes_for(:consent_waiver))
  puts "Created Mentor: #{mentor.email} with password #{mentor.email}"
  puts ""
  puts "============================================================="
  puts ""
end

if (chapter_ambassador = ChapterAmbassadorProfile.create(
    account_attributes: {
      email: "chapter-ambassador@chapter-ambassador.com",
      email_confirmed_at: Time.current,
      password: "chapter-ambassador@chapter-ambassador.com",
      background_check_attributes: {
        candidate_id: "SEEDED!",
        report_id: "SEEDED!",
        status: "clear",
      },
      first_name: "Chapter",
      last_name: "Ambassador",
      date_of_birth: Date.today - 34.years,
      gender: "Prefer not to say",
      city: "Chicago",
      state_province: "IL",
      country: "US",
      timezone: "US/Central",
      seasons: [Season.current.year],
    },
    status: ChapterAmbassadorProfile.statuses[:approved],
    organization_company_name: "Iridescent",
    ambassador_since_year: "I'm new!",
    job_title: "Software Engineer",
    bio: "I am passionate about tech and empowering girls",
  )).valid?
  Geocoding.perform(chapter_ambassador.account).with_save
  chapter_ambassador.account.create_consent_waiver!(FactoryBot.attributes_for(:consent_waiver))
  puts "Created approved chapter ambassador: #{chapter_ambassador.email} with password #{chapter_ambassador.email}"
  puts ""
  puts "============================================================="
  puts ""
end

if (judge = JudgeProfile.create(
    account_attributes: {
      email: "judge@judge.com",
      email_confirmed_at: Time.current,
      password: "judge@judge.com",
      first_name: "Judgey",
      last_name: "McGee",
      date_of_birth: Date.today - 34.years,
      gender: "Female",
      city: "Evanston",
      state_province: "IL",
      country: "US",
      seasons: [Season.current.year],
    },
    company_name: "Boeing",
    job_title: "Aerospace Engineer",
  )).valid?
  judge.account.update_column(:profile_image, "foo/bar/baz.png")
  judge.account.create_consent_waiver!(FactoryBot.attributes_for(:consent_waiver))
  puts "Created Judge: #{judge.email} with password #{judge.email}"
  puts ""
  puts "============================================================="
  puts ""
end

if student_team and student_team.submission.nil?
  submission = TeamSubmission.create(
    team_id: student_team.id,
    integrity_affirmed: true,
  )

  if submission.valid?
    puts "Created Team Submission for the team: #{student_team.name}"
    puts ""
    puts "============================================================="
    puts ""
  end
end

if (admin = AdminProfile.create(
  account_attributes: {
    first_name: "QA",
    last_name: "Admin",
    email: "admin@admin.com",
    password: "admin@admin.com",
    city: "Los Angeles",
    state_province: "CA.",
    country: "US",
    date_of_birth: 100.years.ago,
    gender: "Prefer not to say",
    admin_status: :full_admin,
  }
)).valid?
  puts "Created Admin: #{admin.email}"
end
