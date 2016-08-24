namespace :reports do

  desc "Generate csv about events, detailing team counts and eligible submission counts"
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

  desc "Generate a csv with all parents emails"
  task all_parent_emails: :environment do
    parents = User.where(role: 'student').map{|u| u.parent_email }.uniq

    headers = ["Parent Email"]

    CSV.open("./public/all_parent_emails.csv", "wb") do |csv|
      csv << headers

      parents.each do |parent_email|
        csv << [parent_email]
      end
    end
  end

  desc "Generate a CSV with mentors/coaches and their companies"
  task mentor_coach_companies: :environment do
    CSV.open("./public/mentor_coach_companies.csv", "wb") do |csv|
      csv << %w{Name Email Role Company}

      current_year_users = User.is_registered

      (current_year_users.mentor | current_year_users.coach).each do |user|
        # school is used for company name for non-students
        csv << [user.name, user.email, user.role, user.school]
      end
    end
  end

  desc "Generate a rubrics report for all teams which submitted their app"
  task teams_who_submitted_app: :environment do
    teams = Team.joins(:category).where(year: Setting.year)
    headers = ["Team Name", "Division/Region", "Country", "App Category/Theme", "Team Description", "Semifinalist", "Finalist"]

    CSV.open("./public/teams_who_submitted_app.csv", "wb") do |csv|
      csv << headers

      teams.each do |team|
        row = [team.name, team.region_name, team.country, team.category.name, team.description, team.is_semi_finalist, team.is_finalist]
        csv << row
      end
    end
  end

  desc "Generate a CSV of all current year teams' cities and countries"
  task team_city_countries: :environment do
    teams = Team.includes(team_requests: :user).current

    CSV.open("./public/team_cities_countries.csv", "wb") do |csv|
      csv << %w{Team Coach Email City Country}

      teams.each do |team|
        csv << [team.name, team.coach_name, team.coach_email, team.city, team.country_name]
      end
    end
  end

  desc "Generate a CSV of all submitted teams' cities and countries"
  task submitted_team_city_countries: :environment do
    teams = Team.includes(team_requests: :user).current.is_submitted

    CSV.open("./public/submitted_team_cities_countries.csv", "wb") do |csv|
      csv << %w{City Country}

      teams.each do |team|
        csv << [team.city, team.country_name]
      end
    end
  end

  desc "Generate a CSV of all finalists' parent emails"
  task finalist_parent_emails: :environment do
    teams = Team.includes(team_requests: :user).current.is_finalist

    CSV.open("./public/finalist_parent_emails.csv", "wb") do |csv|
      csv << %w{TeamName ParentEmail}

      teams.each do |team|
        team.students.map(&:parent_email).uniq.each do |email|
          csv << [team.name, email]
        end
      end
    end
  end

  desc "Generate a CSV of all current year users with roles and country"
  task users_roles_countries: :environment do
    CSV.open("./public/users_roles_countries.csv", "wb") do |csv|
      csv << %w{Name Email Country Role}

      User.is_registered.each do |user|
        csv << [user.name, user.email, Country[user.home_country].name, user.role]
      end
    end
  end

  desc "Generate a CSV of all current year iOS submissions with country"
  task ios_submissions: :environment do
    CSV.open("./public/2016_ios_technovation_submissions.csv", "wb") do |csv|
      csv << %w{TeamName AppDescription Country TeamUrl PitchUrl DemoUrl}

      Team.current.is_submitted.ios.each do |team|
        url = Rails.application.routes.url_helpers.team_url(team, host: "http://my.technovationchallenge.org")
        csv << [team.name, team.description, Country[team.country].name, url, team.pitch, team.demo]
      end
    end
  end

  desc "Generate a CSV of all current year submissions tools used"
  task tools_used: :environment do
    CSV.open("./public/2016_tools_used.csv", "wb") do |csv|
      csv << %w{ToolMentioned Count}

      tools = Team.current.is_submitted.collect(&:tools)
      tools = tools.flat_map { |t| t.split(/[,\.;]/).map(&:strip).map(&:downcase).compact }

      tools.uniq.each do |tool|
        csv << [tool, tools.select { |t| t == tool }.count]
      end
    end
  end
end
