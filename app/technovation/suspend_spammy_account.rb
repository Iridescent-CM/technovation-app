module SuspendSpammyAccount
  class << self
    def call(id)
      a = Account.find(id)
      a.skip_existing_password = true
      a.email = "spammy-#{rand(100_000)}@spammy.com"
      a.regenerate_auth_token
      a.save!

      puts "**************************************"
      puts "Suspending #{a.email} - #{a.full_name}"
      puts "Email changed, auth token regenerated"

      if a.judge_profile
        a.judge_profile.submission_scores.each(&:destroy)
        puts "Submission scores soft-deleted"
      end

      puts "**************************************"
    end
  end
end
