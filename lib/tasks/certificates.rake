namespace :certificates do
  desc "Generate 2017 Certificates for completed submissions"
  task completion: :environment do
    TeamSubmission.pluck(:id).each do |submission_id|
      ExportCertificates.(submission_id, "completion")
    end
  end
end
