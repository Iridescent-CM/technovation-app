Sidekiq.default_worker_options = {
  backtrace: true,
  retry: 3,
}

Sidekiq.configure_server do |config|
  if database_url = ENV['DATABASE_URL']
    pool = ENV.fetch("SIDEKIQ_DB_POOL_SIZE") { 25 }
    ActiveRecord::Base.establish_connection "#{database_url}?pool=#{pool}"
  end

  config.default_retries_exhausted = -> (msg, ex) do
    job_id = msg.dig('args', 0, 'job_id')

    unless job_id
      Sidekiq.logger.warn "Unable to get job_id in default_retries_exhausted for #{msg}: #{ex}"
      return
    end

    if db_job = Job.find_by(job_id: job_id)
      db_job.update_column(:status, "dead")
      Sidekiq.logger.warn "Job id=#{db_job.id} job_id=#{job_id} for " +
                          "#{db_job.owner_type} id=#{db_job.owner_id} is dead"
    end
  end
end
