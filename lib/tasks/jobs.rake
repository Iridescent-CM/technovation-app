namespace :jobs do
  desc "Force fail queued jobs older than 'x' number of days by owner type"
  task :force_fail_queued_jobs, [:num_of_days, :owner_type, :dry_run] => :environment do |t, args|

    num_of_days = Integer(args[:num_of_days])
    owner_type = args[:owner_type]
    dry_run = args[:dry_run] != "run"

    puts "DRY RUN: #{dry_run ? 'on' : 'off'}"
    puts "Force failing queued jobs for #{owner_type} that were created before #{(Date.today - num_of_days.days).strftime("%B %d, %Y")}"

    Job.where(created_at: ...num_of_days.days.ago).where(status: "queued").where(owner_type: owner_type).find_each do |job|
      puts "Updating job_id #{job.job_id} - created on #{job.created_at.strftime("%B %d, %Y")}"
      if !dry_run
        job.update_column(:status, "failed")
      end
    end
  end

  desc "Force fail job by id"
  task :force_fail_job_by_id, [:id, :dry_run] => :environment do |t, args|

    id = args[:id]
    dry_run = args[:dry_run] != "run"
    puts "DRY RUN: #{dry_run ? "on" : "off"}"

    job = Job.find(id)
    puts "Updating job #{job.id} - job_id: #{job.job_id} - created_at: #{job.created_at.strftime("%B %d, %Y")}"
    if !dry_run
      job.update_column(:status, "failed")
      puts "Job #{job.id} updated - Status: #{job.status}"
    end
  end
end
