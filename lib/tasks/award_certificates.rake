require "fill_pdfs"

def award_to(account)
  certificates = DetermineCertificates.new(account)

  puts "Awarding to Account ID #{account.id}: #{account.full_name} <#{account.email}>..."
  puts "\tEligible for #{certificates.eligible_types.count}: " +
    certificates.eligible_types.map { |t| t.humanize.titleize }.join(", ")
  puts "\t#{certificates.needed.count} certificate(s) needed"

  FillPdfs.(account)
end

def job_for(account)
  certificates = DetermineCertificates.new(account)

  puts "Awarding to Account ID #{account.id}: #{account.full_name} <#{account.email}>..."
  puts "\tEligible for #{certificates.eligible_types.count}: " +
    certificates.eligible_types.map { |t| t.humanize.titleize }.join(", ")
  puts "\t#{certificates.needed.count} certificate(s) needed"

  certificates.needed.each do |recipient|
    type = recipient.certificate_type.to_s
    account_id = recipient.account.id
    team_id = if recipient.team
                recipient.team.id
              else
                nil
              end

    CertificateJob.perform_later(type, account_id, team_id)
  end
end

namespace :certificates do
  desc "Award certificates to one current account by id"
  task :award_direct, [:account_id] => :environment do |t, args|
    account = Account.current.find(args[:account_id])
    award_to(account)
  end

  desc "Award certificates to a batch of current accounts"
  task :award_batch_direct, [:starting_id, :batch_size] => :environment do |t, args|
    accounts = Account.current
      .where("id > ?", args[:starting_id])
      .first(args[:batch_size])

    accounts.each do |account|
      award_to(account)
    end
  end

  desc "Award certificates to all current accounts"
  task :award_all_direct => :environment do
    accounts = Account.current.order(id: :asc)

    accounts.each do |account|
      award_to(account)
    end
  end

  desc "Create certificate job for one current account by id"
  task :award_job, [:account_id] => :environment do |t, args|
    account = Account.current.find(args[:account_id])
    job_for(account)
  end

  desc "Create certificate jobs for a batch of current accounts"
  task :award_batch_jobs, [:starting_id, :batch_size] => :environment do |t, args|
    accounts = Account.current
      .where("id > ?", args[:starting_id])
      .first(args[:batch_size])

    accounts.each do |account|
      job_for(account)
    end
  end

  desc "Create certificate jobs for all current accounts"
  task :award_all_jobs => :environment do
    accounts = Account.current.order(id: :asc)

    accounts.each do |account|
      job_for(account)
    end
  end
end
