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
end