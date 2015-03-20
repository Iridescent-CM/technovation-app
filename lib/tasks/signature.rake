namespace :signature do
  desc 'Generate signature link for a given user id'
  task :link, [:id] => :environment do |task, args|
    puts SignatureController.generate(args[:id].to_i)
  end
end
