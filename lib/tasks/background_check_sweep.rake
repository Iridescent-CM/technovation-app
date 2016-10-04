desc "Sweep pending background checks"
task sweep_pending_bg_checks: :environment do
  SweepBackgroundChecks.call(:pending)
end

desc "Sweep consider background checks"
task sweep_consider_bg_checks: :environment do
  SweepBackgroundChecks.call(:consider)
end
