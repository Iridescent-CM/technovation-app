require "tempfile"

class ExportScoresJob < ActiveJob::Base
  queue_as :default

  def perform(admin, email, type="summary")
    Tempfile.open(["scores-#{type}-#{Time.now.to_i}-", ".csv"], "./tmp/") do |fh|
      send("make_#{type}", fh)
      export = admin.exports.create!(file: fh)
      FilesMailer.export_ready(admin, export, email).deliver_later
    end
  end

  def make_summary(fh)
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
  end

  def make_detail(fh)
    csv = CSV.new(fh)
    csv << %w{
      Team\ name
      App\ name
      Region
      Division
      Sustainable\ development\ goal
      Judge
      Mentor?
      Team\ region/division\ names
      Complete?
      Total\ score
    }

    SubmissionScore.all.each do |s|
      account = s.judge_profile.account
      csv << [s.team_submission_team_name, s.team_submission_app_name,
              s.team_submission.team.region_name, s.team_submission.team.division.name, s.team_submission.stated_goal,
              account.email, account.mentor_profile.present?, account.team_region_division_names,
              s.complete?, s.total]
    end

    csv.close()
  end
end
