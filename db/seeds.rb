if Expertise.create(name: "Science").valid?
  puts "Created Expertise: #{Expertise.last.name}"
end

if Expertise.create(name: "Engineering").valid?
  puts "Created Expertise: #{Expertise.last.name}"
end

if Expertise.create(name: "Project Management").valid?
  puts "Created Expertise: #{Expertise.last.name}"
end

if (student = StudentAccount.create(email: "student@student.com",
                                    password: "student@student.com",
                                    password_confirmation: "student@student.com",
                                    student_profile_attributes: {
                                      is_in_secondary_school: true,
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
                                   )).valid?
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
                                  password: "mento+chi@mentor.com",
                                  password_confirmation: "mento+chi@mentor.com",
                                  mentor_profile_attributes: {
                                    school_company_name: "Boeing",
                                    job_title: "Aerospace Engineer",
                                    expertise_ids: Expertise.pluck(:id)[0..1],
                                  },
                                  first_name: "Mentor",
                                  last_name: "McGee",
                                  date_of_birth: Date.today - 34.years,
                                  city: "Evanston",
                                  state_province: "IL",
                                  country: "US",
                                 )).valid?
  puts "Created Mentor: #{mentor.email} with password #{mentor.password}"
end


if (admin = AdminAccount.create(email: "admin@admin.com",
                                password: "admin@admin.com",
                                password_confirmation: "admin@admin.com",
                                first_name: "Test",
                                last_name: "Admin",
                                date_of_birth: Date.today,
                                city: "Chicago",
                                state_province: "IL",
                                country: "US",
                               )).valid?
  puts "Created Admin: #{admin.email} with password #{admin.password}"
end
