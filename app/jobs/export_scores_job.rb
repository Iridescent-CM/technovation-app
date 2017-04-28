require "tempfile"

class ExportScoresJob < ActiveJob::Base
  queue_as :default

  def perform(admin, email)
    Tempfile.open(["scores-#{Time.now.to_i}-", ".csv"], "./tmp/") do |fh|
      csv = CSV.new(fh)
      csv << %w{
        Team\ name
        App\ name
        Region
        Division
        Sustainable\ development\ goal
        #\ of\ incomplete\ scores
        #\ of\ completed\ scores
        #\ live
        #\ virtual
        Average\ score
      }

      TeamSubmission.current.each do |s|
        if s.complete?
          csv << [s.team_name, s.app_name, s.team.region_name, s.team.division.name, s.stated_goal,
                  s.submission_scores.incomplete.count, s.submission_scores.complete.count,
                  s.submission_scores.complete.live.count, s.submission_scores.complete.virtual.count,
                  s.average_score]
        end
      end

      csv.close()
      export = admin.exports.create!(file: fh)
      FilesMailer.export_ready(admin, export, email).deliver_later
    end
  end
end
