namespace :legacy_migration do
  desc "Re-upload user paperclip avatars to carrierwave"
  task avatars: :environment do
    ActiveRecord::Base.transaction do
      require './lib/legacy/models/user'
      require 'open-uri'

      Paperclip::Attachment.default_options[:path] = "/users/:attachment/:id_partition/:style/:filename"

      Legacy::User.find_each do |user|
        url = "http:#{ApplicationController.helpers.asset_url(user.avatar.url(:original))}"

        unless url.include?("missing")
          profile_image = open(url)
          account = Account.find_by(email: user.email)
          account.update_attributes(profile_image: profile_image)
          puts "Added profile image for: #{user.email}"
        end
      end
    end
  end
end
