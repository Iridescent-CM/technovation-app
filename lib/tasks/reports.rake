namespace :reports do

  desc "Generate tsv about events, detailing team counts and eligible submission counts"
  task events: :environment do
    puts ['Event ID', 'Event', 'Event date', '# teams', '# eligible submissions'].to_csv(:col_sep => "\t")

    Event.open_for_signup.each do |event|
      eligible, ineligible = event.teams.partition { |t| t.submission_eligible? }
      puts [event.id, event.name, event.whentooccur, event.teams.size, eligible.size].to_csv(:col_sep => "\t")
    end
  end

end
