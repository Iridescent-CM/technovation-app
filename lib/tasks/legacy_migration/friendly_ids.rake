namespace :legacy_migration do
  desc "Migrate the team friendly IDs for legacy support"
  task friendly_ids: :environment do
    ActiveRecord::Base.transaction do
      require './lib/legacy/models/team'

      Legacy::Team.find_each do |legacy_team|
        team = ::Team.find_by(name: legacy_team.name)
        team.update_attributes(friendly_id: legacy_team.slug)
        puts "Set friendly id: #{team.reload.friendly_id}"
      end
    end
  end
end
