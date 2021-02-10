desc "Remove student profiles of mentors"
task remove_student_profiles_of_mentors: :environment do

  accounts = Account.find_by_sql("
select accounts.id as account_id
from accounts
left join student_profiles
  on accounts.id = student_profiles.account_id
left join mentor_profiles
  on accounts.id = mentor_profiles.account_id
where student_profiles.account_id = mentor_profiles.account_id
  ")

  accounts.each do |account|
    account = Account.find(account.account_id)

    account.student_profile.delete

    puts "Student profile deleted for account id: #{account.id}"
  end
end
