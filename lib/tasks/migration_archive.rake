namespace :db do
  namespace :migrate do
    desc "Archive old DB migration files"

    task :archive do
      sh "mkdir -p db/migrate/archive"
      sh "mv db/migrate/*.rb db/migrate/archive"
    end
  end
end
