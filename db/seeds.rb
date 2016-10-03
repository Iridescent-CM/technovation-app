if (student = StudentAccount.create(email: "student@student.com",
                                    password: "student@student.com",
                                    password_confirmation: "student@student.com",
                                    student_profile_attributes: {
                                      school_name: "John Hughes High",
                                      parent_guardian_email: "parent@parent.com",
                                      parent_guardian_name: "Parent Name",
                                    },
                                    first_name: "Student",
                                    last_name: "McGee",
                                    date_of_birth: Date.today - 14.years,
                                    city: "Chicago",
                                    state_province: "IL",
                                    country: "US",
                                    geocoded: "Chicago, IL, US",
                                    pre_survey_completed_at: Time.current,
                                    season_ids: [Season.current.id],
                                   )).valid?
  student.create_parental_consent!(FactoryGirl.attributes_for(:parental_consent))
  puts "Created Student: #{student.email} with password #{student.password}"

  if (team = Team.create(name: "All Star Team",
                        description: "We are allstars",
                        division: Division.none_assigned_yet)).valid?
    team.add_student(student)
    puts "Added student to Team: #{team.name}"
  end
end

if (mentor = MentorAccount.create(email: "mentor@mentor.com",
                                  password: "mentor@mentor.com",
                                  password_confirmation: "mentor@mentor.com",
                                  mentor_profile_attributes: {
                                    school_company_name: "Boeing",
                                    job_title: "Aerospace Engineer",
                                    expertise_ids: Expertise.pluck(:id)[0..1],
                                  },
                                  background_check_attributes: {
                                    candidate_id: "SEEDED!",
                                    report_id: "SEEDED!",
                                    status: "clear"
                                  },
                                  first_name: "Mentor",
                                  last_name: "McGee",
                                  date_of_birth: Date.today - 34.years,
                                  city: "Boulder",
                                  state_province: "CO",
                                  country: "US",
                                  geocoded: "Boulder, CO, US",
                                  season_ids: [Season.current.id],
                                 )).valid?
  puts "Created Mentor: #{mentor.email} with password #{mentor.password}"

  if (team = Team.create(name: "Fun Times Team",
                         description: "We are fun times havers",
                         season_ids: [Season.current.id],
                         division: Division.none_assigned_yet)).valid?
    team.add_mentor(mentor)
    puts "Added mentor to Team: #{team.name}"
  end
end

if (mentor = MentorAccount.create(email: "mentor+chi@mentor.com",
                                  password: "mentor+chi@mentor.com",
                                  password_confirmation: "mentor+chi@mentor.com",
                                  mentor_profile_attributes: {
                                    school_company_name: "Boeing",
                                    job_title: "Aerospace Engineer",
                                    expertise_ids: Expertise.pluck(:id)[0..1],
                                    bio: "Cool chicago mentor",
                                  },
                                  background_check_attributes: {
                                    candidate_id: "SEEDED!",
                                    report_id: "SEEDED!",
                                    status: "clear"
                                  },
                                  first_name: "Mentor",
                                  last_name: "McGee",
                                  date_of_birth: Date.today - 34.years,
                                  city: "Evanston",
                                  state_province: "IL",
                                  country: "US",
                                  geocoded: "Evanston, IL, US",
                                  season_ids: [Season.current.id],
                                 )).valid?
  mentor.update_column(:profile_image, "foo/bar/baz.png")
  mentor.create_consent_waiver!(FactoryGirl.attributes_for(:consent_waiver))
  puts "Created Mentor: #{mentor.email} with password #{mentor.password}"
end

if (ra = RegionalAmbassadorAccount.create(email: "ra@ra.com",
                                          password: "ra@ra.com",
                                          password_confirmation: "ra@ra.com",
                                          regional_ambassador_profile_attributes: {
                                            organization_company_name: "Iridescent",
                                            ambassador_since_year: "I'm new!",
                                            job_title: "Software Engineer",
                                            bio: "I am passionate about tech and empowering girls",
                                          },
                                          background_check_attributes: {
                                            candidate_id: "SEEDED!",
                                            report_id: "SEEDED!",
                                            status: "clear"
                                          },
                                          first_name: "RA",
                                          last_name: "Ambassador",
                                          date_of_birth: Date.today - 34.years,
                                          city: "Chicago",
                                          state_province: "IL",
                                          country: "US",
                                          geocoded: "Chicago, IL, US",
                                          pre_survey_completed_at: Time.current,
                                          season_ids: [Season.current.id],
                                         )).valid?
  ra.create_consent_waiver!(FactoryGirl.attributes_for(:consent_waiver))
  puts "Created RA: #{ra.email} with password #{ra.password}"
end

if (judge = JudgeAccount.create(email: "judge@judge.com",
                                password: "judge@judge.com",
                                password_confirmation: "judge@judge.com",
                                judge_profile_attributes: {
                                  company_name: "Boeing",
                                  job_title: "Aerospace Engineer",
                                },
                                background_check_attributes: {
                                  candidate_id: "SEEDED!",
                                  report_id: "SEEDED!",
                                  status: "clear"
                                },
                                first_name: "Judgey",
                                last_name: "McGee",
                                date_of_birth: Date.today - 34.years,
                                city: "Evanston",
                                state_province: "IL",
                                country: "US",
                                geocoded: "Evanston, IL, US",
                                season_ids: [Season.current.id],
                               )).valid?
  judge.update_column(:profile_image, "foo/bar/baz.png")
  judge.create_consent_waiver!(FactoryGirl.attributes_for(:consent_waiver))
  puts "Created Judge: #{judge.email} with password #{judge.password}"
end
