desc "Drop-out a mentor: Mark season registration as dropped-out, remove team memberships, unsubscribe from newsletters, remove searchable"
task mentor_drop_out: :environment do
  email = ENV.fetch("EMAIL") { abort("Set EMAIL key to proceed") }
  if mentor = MentorAccount.where("lower(email) = ?", email.downcase).first
    DropOutMentorJob.perform_now(mentor)
    puts "#{mentor.full_name} has been dropped out of Season #{Season.current.year}!"
  else
    abort("Mentor not found! #{email}!")
  end
end
