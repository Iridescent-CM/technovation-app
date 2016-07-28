namespace :bootstrap do
  desc "Create expertises"
  task expertises: :environment do
    %w{science engineering project_management finance marketing design}.each do |name|
      if (ex = Expertise.find_or_create_by(name: name.humanize)).persisted?
        puts "Created Expertise: #{ex.reload.name}"
      else
        puts "Failed to create expertise #{name}"
      end
    end
  end
end
