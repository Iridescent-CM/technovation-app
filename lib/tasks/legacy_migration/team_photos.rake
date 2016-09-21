namespace :legacy_migration do
  desc "Re-upload team paperclip photos to carrierwave"
  task team_photos: :environment do
    require './lib/legacy/models/team'
    require 'open-uri'

    Legacy::Team.find_each do |legacy_team|
      url = "http:#{legacy_team.avatar.url(:original)}"

      unless url.nil? or url.include?("missing")
        begin
          team = Team.find_by(name: legacy_team.name)
          team.remote_team_photo_url = url
          team.save
          puts "Added photo for: #{team.name}"
        rescue
          puts "Failed photo upload."
        end
      end
    end
  end
end
