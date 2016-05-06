namespace :reports do

  desc "Generate tsv about events, detailing team counts and eligible submission counts"
  task events: :environment do
    puts ['Event ID', 'Event', 'Event date', '# teams', '# eligible submissions'].to_csv(:col_sep => "\t")

    Event.open_for_signup.each do |event|
      eligible, ineligible = event.teams.partition { |t| t.submission_eligible? }
      puts [event.id, event.name, event.whentooccur, event.teams.size, eligible.size].to_csv(:col_sep => "\t")
    end
  end

  desc "Generate a score report on teams"
  task team_scores: :environment do
    teams = Team.joins(:rubrics)
                    .where('teams.year = 2016 AND teams.event_id = 73')
                    .select { |team|
                      !team.ineligible? && team.submission_eligible?
                    }

    headers = ["Team Name", "Region", "City", "State", "Country", "Division",
                "Year", "Event", "Rubrics count", "Rubrics average",
                "Quarterfinal average", "Launched (TRUE/FALSE)"]

    CSV.open("./public/team_scores.csv", "wb") do |csv|
      csv << headers

      teams.each do |team|
        csv << [team.name, team.region_name, team.members.first.home_city, team.state, team.country,
                team.division, team.year, team.event_name, team.rubrics.count,
                team.avg_score, team.avg_quarterfinal_score, team.rubrics.first.launched]
      end
    end
  end
end
