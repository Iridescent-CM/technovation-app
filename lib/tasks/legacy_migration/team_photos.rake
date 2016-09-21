namespace :legacy_migration do
  desc "Re-upload team paperclip photos to carrierwave"
  task team_photos: :environment do
    ActiveRecord::Base.transaction do
      require './lib/legacy/models/team'
      require 'open-uri'

      Paperclip::Attachment.default_options[:path] = "/teams/:attachment/:id_partition/:style/:filename"

      Legacy::Team.find_each do |legacy_team|
        url = "http:#{legacy_team.avatar.url(:original)}"

        unless url.nil? or url.include?("missing")
          begin
            team_photo = open(url)
            team = Team.find_by(name: legacy_team.name)
            team.update_attributes(team_photo: team_photo)
            puts "Added photo for: #{team.name}"
          rescue
            puts "Failed photo upload."
          end
        end
      end
    end
  end
end
