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
                                    pre_survey_completed_at: Time.current,
                                   )).valid?
  student.create_parental_consent!(FactoryGirl.attributes_for(:parental_consent))
  puts "Created Student: #{student.email} with password #{student.password}"
end

if (mentor = MentorAccount.create(email: "mentor@mentor.com",
                                  password: "mentor@mentor.com",
                                  password_confirmation: "mentor@mentor.com",
                                  mentor_profile_attributes: {
                                    school_company_name: "Boeing",
                                    job_title: "Aerospace Engineer",
                                    expertise_ids: Expertise.pluck(:id)[0..1],
                                  },
                                  first_name: "Mentor",
                                  last_name: "McGee",
                                  date_of_birth: Date.today - 34.years,
                                  city: "Boulder",
                                  state_province: "CO",
                                  country: "US",
                                 )).valid?
  puts "Created Mentor: #{mentor.email} with password #{mentor.password}"
end

if (mentor = MentorAccount.create(email: "mentor+chi@mentor.com",
                                  password: "mentor+chi@mentor.com",
                                  password_confirmation: "mentor+chi@mentor.com",
                                  mentor_profile_attributes: {
                                    school_company_name: "Boeing",
                                    job_title: "Aerospace Engineer",
                                    expertise_ids: Expertise.pluck(:id)[0..1],
                                    bio: "Cool chicago mentor",
                                    background_check_completed_at: Time.current,
                                  },
                                  first_name: "Mentor",
                                  last_name: "McGee",
                                  date_of_birth: Date.today - 34.years,
                                  city: "Evanston",
                                  state_province: "IL",
                                  country: "US",
                                 )).valid?
  mentor.update_column(:profile_image, "foo/bar/baz.png")
  mentor.create_consent_waiver!(FactoryGirl.attributes_for(:consent_waiver))
  puts "Created Mentor: #{mentor.email} with password #{mentor.password}"
end
