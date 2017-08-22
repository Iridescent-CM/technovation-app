desc "Bootstrap the db"
task bootstrap: :environment do
  %w{science coding engineering project_management finance marketing design}.each do |name|
    if Expertise.exists?(name: name.titleize)
      puts "Found Expertise: #{name.titleize}"
    elsif Expertise.create(name: name.titleize).persisted?
      puts "Created Expertise: #{name.titleize}"
    else
      puts "Failed to find or create Expertise: #{name.titleize}"
    end
  end

  email = ENV.fetch("ADMIN_EMAIL")

  if AdminProfile.joins(:account).where("accounts.email = ?", email).any?
    puts "Found Admin: #{email}"
  else
    AdminProfile.create!(
      account_attributes: {
        first_name: "Oracle",
        last_name: "Staff",
        email: email,
        password: ENV.fetch("ADMIN_PASSWORD"),
        city: "Guadalajara",
        state_province: "Jal.",
        country: "MX",
        date_of_birth: 100.years.ago,
      }
    )
    puts "Created Admin: #{email}"
  end
end
