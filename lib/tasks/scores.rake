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
      team\ deleted?
      submission\ deleted?
      team\ name
      app\ name
      team\ event\ name
      event\ status
      judge\ email
      live\ judge?
      judge\ account\ deleted?
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

      sub = TeamSubmission.with_deleted.find(score.team_submission_id)
      team = Team.with_deleted.find(sub.team_id)
      team_rpe = team.selected_regional_pitch_event
      judge_profile = JudgeProfile.with_deleted.find(score.judge_profile_id)
      judge_account = Account.with_deleted.find(judge_profile.account_id)

      virtual_mismatch = if team_rpe.virtual? && judge_profile.live_event?
          "yes"
        elsif team_rpe.live? && team_rpe.official? && !judge_profile.live_event?
          "yes"
        else
          "no"
        end

      event_mismatch = if team_rpe.virtual? and !judge_profile.live_event?
          "no"
        elsif judge_profile.regional_pitch_events.include?(team_rpe)
          "no"
        else
          "yes"
        end

      event_official_status = if sub.deleted_at.nil? && team.deleted_at.nil?
        score.event_official_status
      else
        "-"
      end

      puts [
        score.id,
        score.complete? ? 'yes' : 'no',
        score.created_at,
        score.deleted_at,
        distance_in_words,
        distance_in_minutes,
        score.approved? ? 'yes' : 'no',
        team.deleted_at.nil? ? 'no' : 'yes',
        sub.deleted_at.nil? ? 'no' : 'yes',
        sub.team_name,
        sub.app_name,
        team_rpe.name,
        event_official_status,
        judge_account.email,
        judge_profile.live_event? ? 'yes' : 'no',
        judge_account.deleted_at.nil? ? 'no' : 'yes',
        virtual_mismatch,
        event_mismatch
      ].to_csv
    end
  end

  desc 'soft delete incomplete submission score by judge profile id'
  task :soft_delete!, [:judge_profile_id] => :environment do |t, args|
    puts "Soft deleting submission scores for judge profile id: #{args[:judge_profile_id]}"
    SubmissionScore.current.where(judge_profile_id: args[:judge_profile_id]).destroy_all
  end
end
