require "./lib/invite_chapter_ambassador"

task invite_chapter_ambassadors: :environment do
  ActiveRecord::Base.transaction do
    attempts = []

    CSV.foreach(
      "./lib/2018_ra_import.csv",
      headers: true,
      header_converters: :symbol
    ) do |row|
      next if row[:date_of_birth].blank? || row[:bio].blank?

      row[:date_of_birth] = Date.strptime(row[:date_of_birth], "%m/%d/%Y")

      begin
        attempts << InviteChapterAmbassador.(row, $stdout)
      rescue => e
        attempts = []
        raise e
      end
    end

    attempts.compact.each do |attempt|
      RegistrationMailer.admin_permission(attempt.id).deliver_now
    end
  end
end
