if Rails.env.test?
  IndexModelJob.force_refresh true
end
