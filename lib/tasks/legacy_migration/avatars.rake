namespace :legacy_migration do
  desc "Re-upload user paperclip avatars to carrierwave"
  task avatars: :environment do
    require './lib/legacy/models/user'
    require 'open-uri'

    Legacy::User.find_each do |user|
      url = "https:#{user.avatar.url(:original)}"

      unless url.include?("missing")
        begin
          account = Account.where("lower(email) = ?", user.email.downcase).first
          account.remote_profile_image_url = url
          account.save
          puts "Added profile image for: #{user.email}"
        rescue
          puts "Failed profile image upload."
        end
      end
    end
  end
end
