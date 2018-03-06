desc "Update CS from maxmind"
task update_cs: :environment do
  CS.update
end
