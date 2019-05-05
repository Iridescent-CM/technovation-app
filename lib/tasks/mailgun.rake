# FIXME: This causes smtp delivery to fail??
# require 'mailgun-ruby'

# namespace :mailgun do
#   task check_ready_submissions: :environment do
#     mg_client = Mailgun::Client.new ENV.fetch("MAILGUN_PRIVATE_KEY")
#     mg_events = Mailgun::Events.new(mg_client, "technovationchallenge.org")
#
#     results = mg_events.get({
#       :limit => 300,
#       :event => "accepted",
#       #:begin => "Wed, Apr 24, 2019 00:00:00 GMT",
#       #:end => "Fri, Apr 26, 2019 23:59:00 GMT",
#       :subject => "Your submission is ready for judging!"
#     }).to_h
#
#     # Recipients can receive this email more than once.
#     # First we will collect and de-dupe email addresses.
#     emails = {}
#     loop do
#       results['items'].each do |result|
#         email = result['recipient']
#         emails[email] = emails.fetch(email, 0) + 1
#       end
#
#       STDERR.puts "Unique emails collected: #{emails.keys.length}"
#       results = mg_events.next.to_h
#       break if results['items'].empty?
#     end
#
#     # Start writing CSV data
#     puts %w{
#       email
#       count
#       scope
#       team\ name
#       app\ name
#       status
#       % complete
#     }.to_csv
#
#     processed = 0
#     emails.each do |email, count|
#       processed = processed + 1
#       if processed % 100 == 0
#         STDERR.puts "Processed #{processed} emails"
#       end
#
#       acc = Account.find_by(email: email)
#
#       # I think multiple environments use the same key, so not
#       # all accounts will be found.
#       if acc.nil?
#         puts [email, count, "not found"].to_csv
#         next
#       end
#
#       # Not a student? Then we're done.
#       unless acc.scope_name == "student"
#         puts [email, count, acc.scope_name].to_csv
#         next
#       end
#
#       student = acc.student_profile
#       team = student.team
#
#       # Not on a team? Weird, but okay.
#       if team.nil?
#         puts [email, count, acc.scope_name, team.name].to_csv
#         next
#       end
#
#       puts [
#         email,
#         count,
#         acc.scope_name,
#         team.name,
#         team.submission.app_name,
#         team.human_status,
#         team.submission.percent_complete
#       ].to_csv
#     end
#   end
# end
