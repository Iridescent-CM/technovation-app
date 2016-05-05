namespace :dev do
  desc "List the users in the development environment"
  task :list_users => :environment do
    return unless Rails.env.development?

    User.all.each do |user|
      $stdout.write("#{user.role} - #{user.email}\n")
    end

    $stdout.write("All passwords for seeded users are `testtest`\n")
  end
end
