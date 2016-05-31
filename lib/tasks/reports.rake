namespace :reports do
  desc "Generate tsv about events, detailing team counts and eligible submission counts"
  task events: :environment do
    puts ['Event ID', 'Event', 'Event date', '# teams', '# eligible submissions'].to_csv(:col_sep => "\t")

    Event.open_for_signup.each do |event|
      eligible, _ = event.teams.partition { |t| t.submission_eligible? }
      puts [event.id, event.name, event.when_to_occur, event.teams.size, eligible.size].to_csv(:col_sep => "\t")
    end
  end

  desc "Generate a score report on teams"
  task team_scores: :environment do
    teams = Team.where(year: 2016, event_id: 73)
                .select do |team|
                  !team.ineligible? && team.submission_eligible?
                end

    headers = ["Team Name", "Team ID", "Region", "City", "State", "Country",
               "Division", "Year", "Event", "Rubrics count", "Rubrics average",
               "Quarterfinal average", "Launched (TRUE/FALSE)"]

    CSV.open("./public/team_scores.csv", "wb") do |csv|
      csv << headers

      teams.each do |team|
        csv << [team.name, team.id, team.region_name, team.members.first.home_city,
                team.state, team.country, team.division, team.year, team.event_name,
                team.rubrics.quarterfinal.count, team.avg_score, team.avg_quarterfinal_score,
                team.rubrics.quarterfinal.first.try(:launched) || false]
      end
    end
  end

  desc "Generate a rubrics report on teams"
  task team_rubrics: :environment do
    rubrics = Rubric.joins(:team)
                    .quarterfinal
                    .where('teams.event_id = ?', 73)
                    .select do |rubric|
                      team = rubric.team
                      !team.ineligible? && team.submission_eligible?
                    end

    headers = ["Team Name", "Team ID", "Region", "Division", "Event"]
    headers += CalculateScore.scoring_attributes.map(&:to_s)
                                                .map(&:humanize)
                                                .map(&:titleize)
    headers += %w{launched score}

    CSV.open("./public/team_rubrics.csv", "wb") do |csv|
      csv << headers

      rubrics.each do |rubric|
        team = rubric.team

        row = [team.name, team.id, team.region_name, team.division, team.event_name]
        row += CalculateScore.scoring_attributes.map do |a|
                 rubric.public_send(a)
               end
        row += [!!rubric.launched, rubric.score]

        csv << row
      end
    end
  end

  desc "Generate a rubrics report on semifinalist teams"
  task semifinal_team_rubrics: :environment do
    rubrics = Rubric.joins(:team)
                    .where(stage: Rubric.stages["semifinal"])
                    .select do |rubric|
                      team = rubric.team and team.year = Setting.year
                    end

    headers = ["Team Name", "Team ID", "Region", "Division", "Event", "Avg Score", "Avg Quarterfinal Score", "Avg SemiFinal Score"]
    headers += CalculateScore.scoring_attributes.map(&:to_s)
                                                .map(&:humanize)
                                                .map(&:titleize)
    headers += %w{launched score}

    CSV.open("./public/semifinal_team_rubrics.csv", "wb") do |csv|
      csv << headers

      rubrics.each do |rubric|
        team = rubric.team

        row = [team.name, team.id, team.region_name, team.division, team.event_name, team.avg_score, team.avg_quarterfinal_score, team.avg_semifinal_score]
        row += CalculateScore.scoring_attributes.map do |a|
                 rubric.public_send(a)
               end
        row += [!!rubric.launched, rubric.score]

        csv << row
      end
    end
  end

  desc "Generate a csv with parent's email for students in the current season"
  task parent_emails: :environment do
    parents = User.where(is_registered: true).where(role: 'student').map{|u| u.parent_email }

    headers = ["Parent Email"]

    CSV.open("./public/parent_emails_test.csv", "wb") do |csv|
      csv << headers

      parents.each do |parent_email|
        csv << [parent_email]
      end
    end
  end


end
