ActionMailer::Base.perform_deliveries = false
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
                                      geocoded: "Chicago, IL, US",
                                      season_ids: [Season.current.id],
                                    })).valid?
  student.create_parental_consent!(FactoryGirl.attributes_for(:parental_consent))
  puts ""
  puts "============================================================="
  puts ""
  puts "Created Student: #{student.email} with password #{student.account.password}"
  puts ""
  puts "============================================================="
  puts ""

  if (team = Team.create(name: "All Star Team",
                        description: "We are allstars",
                        division: Division.none_assigned_yet)).valid?
    team.add_student(student)
    puts "Added student to Team: #{team.name}"
    puts ""
    puts "============================================================="
    puts ""
  end
end

if (student = StudentProfile.create(school_name: "John Hughes High",
                                    parent_guardian_email: "parent@parent.com",
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
                                      geocoded: "Chicago, IL, US",
                                      season_ids: [Season.find_or_create_by(year: Season.current.year - 1).id],
                                    })).valid?
  student.create_parental_consent!(FactoryGirl.attributes_for(:parental_consent))
  puts ""
  puts "============================================================="
  puts ""
  puts "Created #{Season.current.year - 1} Student: #{student.email} with password #{student.account.password}"
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
                                      geocoded: "Chicago, IL, US",
                                      season_ids: [Season.find_or_create_by(year: Season.current.year - 2).id],
                                    })).valid?
  student.create_parental_consent!(FactoryGirl.attributes_for(:parental_consent))
  puts ""
  puts "============================================================="
  puts ""
  puts "Created #{Season.current.year - 2} Student: #{student.email} with password #{student.account.password}"
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
      date_of_birth: Date.today - 34.years,
      city: "Boulder",
      state_province: "CO",
      country: "US",
      geocoded: "Boulder, CO, US",
      season_ids: [Season.current.id],

      background_check_attributes: {
        candidate_id: "SEEDED!",
        report_id: "SEEDED!",
        status: "clear",
      },
    },
    school_company_name: "Boeing",
    job_title: "Aerospace Engineer",
    expertise_ids: Expertise.pluck(:id)[0..1],
  )).valid?
  puts "Created Mentor: #{mentor.email} with password #{mentor.account.password}"
  puts ""
  puts "============================================================="
  puts ""

  if (team = Team.create(name: "Fun Times Team",
                         description: "We are fun times havers",
                         season_ids: [Season.current.id],
                         division: Division.none_assigned_yet)).valid?
    team.add_mentor(mentor)
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

      background_check_attributes: {
        candidate_id: "SEEDED!",
        report_id: "SEEDED!",
        status: "clear",
      },

      first_name: "Joe",
      last_name: "McGee",
      date_of_birth: Date.today - 34.years,
      city: "Evanston",
      state_province: "IL",
      country: "US",
      geocoded: "Evanston, IL, US",
      season_ids: [Season.current.id],
    },
    school_company_name: "Boeing",
    job_title: "Aerospace Engineer",
    expertise_ids: Expertise.pluck(:id)[0..1],
    bio: "Cool chicago mentor",
  )).valid?
  mentor.account.update_column(:profile_image, "foo/bar/baz.png")
  mentor.account.create_consent_waiver!(FactoryGirl.attributes_for(:consent_waiver))
  puts "Created Mentor: #{mentor.email} with password #{mentor.account.password}"
  puts ""
  puts "============================================================="
  puts ""
end

if (ra = RegionalAmbassadorProfile.create(
    account_attributes: {
      email: "ra@ra.com",
      password: "ra@ra.com",
      background_check_attributes: {
        candidate_id: "SEEDED!",
        report_id: "SEEDED!",
        status: "clear",
      },
      first_name: "RA",
      last_name: "Ambassador",
      date_of_birth: Date.today - 34.years,
      city: "Chicago",
      state_province: "IL",
      country: "US",
      geocoded: "Chicago, IL, US",
      season_ids: [Season.current.id],
    },
    organization_company_name: "Iridescent",
    ambassador_since_year: "I'm new!",
    job_title: "Software Engineer",
    bio: "I am passionate about tech and empowering girls",
  )).valid?
  ra.account.create_consent_waiver!(FactoryGirl.attributes_for(:consent_waiver))
  puts "Created RA: #{ra.email} with password #{ra.account.password}"
  puts ""
  puts "============================================================="
  puts ""
end

if (judge = JudgeProfile.create(
    account_attributes: {
      email: "judge@judge.com",
      password: "judge@judge.com",
      first_name: "Judgey",
      last_name: "McGee",
      date_of_birth: Date.today - 34.years,
      city: "Evanston",
      state_province: "IL",
      country: "US",
      geocoded: "Evanston, IL, US",
      season_ids: [Season.current.id],
    },
    company_name: "Boeing",
    job_title: "Aerospace Engineer",
  )).valid?
  judge.account.update_column(:profile_image, "foo/bar/baz.png")
  judge.account.create_consent_waiver!(FactoryGirl.attributes_for(:consent_waiver))
  puts "Created Judge: #{judge.email} with password #{judge.account.password}"
  puts ""
  puts "============================================================="
  puts ""
end
