desc "Add 'beginner' to the divisions table"
task add_beginner_to_divisions_table: :environment do
  Division.create(name: Division.names[:beginner])
end
