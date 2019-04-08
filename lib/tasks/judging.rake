require './lib/set_semifinalists'

namespace :judging do
  desc "Validate CSV for setting semifinalists"
  task :check_semifinalists, [:filename] => :environment do |t, args|
    SetSemifinalists.read(args[:filename]).dry_run
  end

  desc "Set semifinalists from CSV"
  task :set_semifinalists, [:filename] => :environment do |t, args|
    ssf = SetSemifinalists.read(args[:filename])

    ssf.logger.info "### DRY RUN: true"
    ssf.dry_run

    ssf.logger.info "### DRY RUN: false"
    ssf.perform!
  end
end

