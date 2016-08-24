namespace :bootstrap do
  desc "Bootstrap the db"
  task technovation: :environment do
    %w{science engineering project_management finance marketing design}.each do |name|
      if (ex = Expertise.find_or_create_by(name: name.humanize)).persisted?
        puts "Created Expertise: #{ex.reload.name}"
      else
        puts "Failed to create expertise #{name}"
      end
    end

    admin = AdminAccount.create!(first_name: "Technovation",
                                 last_name: "Staff",
                                 email: "info@technovationchallenge.org",
                                 password: ENV.fetch("ADMIN_PASSWORD"),
                                 password_confirmation: ENV.fetch("ADMIN_PASSWORD"),
                                 city: "San Francisco",
                                 state_province: "CA",
                                 country: "US",
                                 date_of_birth: 100.years.ago)
    puts "Created Admin: #{admin.email}"
  end
end
