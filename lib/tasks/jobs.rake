namespace :jobs do
  desc "Force fail queued jobs between today and 1 month ago by owner type"
  task :force_fail_queued_jobs, [:owner_type] => :environment do |t, args|
    puts "Force failing queued jobs for #{args[:owner_type]}"
    Job.where(created_at: (Date.today - 1.month)..Date.today).where(status: "queued").where(owner_type: args[:owner_type]).find_each do |job|
      puts "Updating job_id #{job.job_id}"
      job.update_column(:status, "failed")
    end
  end
end
