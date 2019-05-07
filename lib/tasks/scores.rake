namespace :scores do
  desc "Set all nil to 0"
  task default_nil_to_zero: :environment do
    SubmissionScore.find_each do |score|
      score.attributes.each do |k, v|
        next if k.match(/comment/)
        next if k == "id"
        next if k.match(/_at$/)
        next if k.match(/_id$/)
        score[k] = 0 if v.nil?
      end

      score.save!
    end

    SubmissionScore.find_each do |score|
      score.attributes.each do |k, v|
        score[k] = nil if k.match(/comment/) && v == "0"
      end

      score.save!
    end
  end

  desc "Update all score summaries for completed submissions"
  task set_score_summaries_of_completed: :environment do
    TeamSubmission.current.complete.find_each do |ts|
      ts.update_score_summaries
      ts.reload
      puts "Updated #{ts.app_name} summaries to"
      puts "  quarterfinals range: #{ts.quarterfinals_score_range}"
      puts "    quarterfinals avg: #{ts.quarterfinals_average_score}"
      puts "     semifinals range: #{ts.semifinals_score_range}"
      puts "       semifinals avg: #{ts.semifinals_average_score}"
    end
  end

  task report_on_deleted: :environment do
    puts %w{
      id
      complete?
      created\ at
      deleted\ at
      deleted\ after
      deleted\ after\ in\ minutes
      approved?
      team\ name
      app\ name
      team\ event\ name
      event\ status
      judge\ email
      live\ judge?
      judge\ deleted?
      judge/team\ virtual\ mismatch?
      event\ mismatch?
    }.to_csv

    SubmissionScore.current.only_deleted.find_each do |score|
      distance_in_minutes = ((score.deleted_at - score.created_at)/60.0).round

      distance_in_words = case distance_in_minutes
        when 0 then "less than 1 minute"
        when 2...45 then "#{distance_in_minutes} minutes"
        when 45...90 then "about an hour"
        when 90...1440 then "about #{(distance_in_minutes / 60.0).round} hours"
        when 1440...2520 then "about a day"
        else "about #{(distance_in_minutes / 1440.0).round} days"
      end

      team = score.team
      sub = score.team_submission
      team_rpe = team.selected_regional_pitch_event
      judge = score.judge_profile

      virtual_mismatch = if team_rpe.virtual? && judge.live_event?
          "yes"
        elsif team_rpe.official? && !judge.live_event?
          "yes"
        else
          "no"
        end

      event_mismatch = if judge.regional_pitch_events.include?(team_rpe)
          "no"
        else
          "yes"
        end

      puts [
        score.id,
        score.complete? ? 'yes' : 'no',
        score.created_at,
        score.deleted_at,
        distance_in_words,
        distance_in_minutes,
        score.approved? ? 'yes' : 'no',
        sub.team_name,
        sub.app_name,
        team_rpe.name,
        score.event_official_status,
        judge.account.email,
        judge.live_event? ? 'yes' : 'no',
        judge.account.deleted_at.nil? ? 'no' : 'yes',
        virtual_mismatch,
        event_mismatch
      ].to_csv
    end
  end
end
