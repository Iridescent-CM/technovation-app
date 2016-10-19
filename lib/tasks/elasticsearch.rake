require 'elasticsearch/rails/tasks/import'

task bootstrap_search_engine: :environment do
  Account.import(force: true)
  Team.import(force: true)
  puts "Done."
end
