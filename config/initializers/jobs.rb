if Rails.env.test?
  IndexTeamJob.force_refresh true
end
