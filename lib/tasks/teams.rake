namespace :teams do
  desc "Reconsider divisions"
  task reconsider_divisions: :environment do
    i = 0

    Team.current.find_each do |t|
      division = t.division_name
      reconsider = t.reconsider_division.name

      if division != reconsider
        i += 1
        t.reconsider_division_with_save
        puts "#{t.name} changed #{division} to #{reconsider}"
        puts ""
        puts ""
      end
    end

    puts "Changed divisions for #{i} teams"
  end
end
